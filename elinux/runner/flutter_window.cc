// Copyright 2021 Sony Corporation. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter_window.h"

#include <chrono>
#include <cmath>
#include <iostream>
#include <thread>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <iomanip>
#include <sstream>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(
    const flutter::FlutterViewController::ViewProperties view_properties,
    const flutter::DartProject project)
    : view_properties_(view_properties), project_(project) {}

bool FlutterWindow::OnCreate() {
  flutter_view_controller_ = std::make_unique<flutter::FlutterViewController>(
      view_properties_, project_);

  // Ensure that basic setup of the controller was successful.
  if (!flutter_view_controller_->engine() ||
      !flutter_view_controller_->view()) {
    return false;
  }

  // Register Flutter plugins.
  RegisterPlugins(flutter_view_controller_->engine());

  SetupAlarmChannel(flutter_view_controller_->engine()->messenger());

  return true;
}

void FlutterWindow::SetupAlarmChannel(flutter::BinaryMessenger* messenger) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, "com.example.clock/alarm",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler([](const auto& call, auto result) {
    if (call.method_name() == "setAlarm") {
      const auto* arguments =
          std::get_if<flutter::EncodableMap>(call.arguments());
      auto id = std::get<std::string>(
          arguments->at(flutter::EncodableValue("id")));
      auto timestamp = std::get<int64_t>(
          arguments->at(flutter::EncodableValue("timestamp")));

      // Convert timestamp to human-readable format for systemd-run
      // timestamp is in milliseconds
      std::time_t t = timestamp / 1000;
      std::tm* tm = std::localtime(&t);
      std::ostringstream oss;
      oss << std::put_time(tm, "%Y-%m-%d %H:%M:%S");
      std::string time_str = oss.str();

      // Cancel existing alarm with same id first to avoid duplicates
      std::string cancel_command = "systemctl --user stop alarm-" + id + ".timer 2>/dev/null";
      system(cancel_command.c_str());

      // schedule systemd-run timer
      // We use --unit to give it a predictable name for cancellation
      // The command triggers a notification and plays a sound
      std::string alarm_command =
          "systemd-run --user --unit=alarm-" + id + " --on-calendar=\"" +
          time_str +
          "\" /bin/bash -c \"/usr/bin/notify-send 'Alarm' 'Time to wake up!' --icon=alarm-clock && /usr/bin/aplay /usr/share/sounds/alsa/Front_Center.wav\"";

      std::cout << "Executing: " << alarm_command << std::endl;
      int status = system(alarm_command.c_str());

      if (status == 0) {
        result->Success();
      } else {
        result->Error("failed_to_set", "Failed to execute systemd-run");
      }
    } else if (call.method_name() == "cancelAlarm") {
      const auto* arguments =
          std::get_if<flutter::EncodableMap>(call.arguments());
      auto id = std::get<std::string>(
          arguments->at(flutter::EncodableValue("id")));

      std::string command = "systemctl --user stop alarm-" + id + ".timer";
      std::cout << "Executing: " << command << std::endl;
      system(command.c_str());
      result->Success();
    } else {
      result->NotImplemented();
    }
  });
}

void FlutterWindow::OnDestroy() {
  if (flutter_view_controller_) {
    flutter_view_controller_ = nullptr;
  }
}

void FlutterWindow::Run() {
  // Main loop.
  auto next_flutter_event_time =
      std::chrono::steady_clock::time_point::clock::now();
  while (flutter_view_controller_->view()->DispatchEvent()) {
    // Wait until the next event.
    {
      auto wait_duration =
          std::max(std::chrono::nanoseconds(0),
                   next_flutter_event_time -
                       std::chrono::steady_clock::time_point::clock::now());
      std::this_thread::sleep_for(
          std::chrono::duration_cast<std::chrono::milliseconds>(wait_duration));
    }

    // Processes any pending events in the Flutter engine, and returns the
    // number of nanoseconds until the next scheduled event (or max, if none).
    auto wait_duration = flutter_view_controller_->engine()->ProcessMessages();
    {
      auto next_event_time = std::chrono::steady_clock::time_point::max();
      if (wait_duration != std::chrono::nanoseconds::max()) {
        next_event_time =
            std::min(next_event_time,
                     std::chrono::steady_clock::time_point::clock::now() +
                         wait_duration);
      } else {
        // Wait for the next frame if no events.
        auto frame_rate = flutter_view_controller_->view()->GetFrameRate();
        next_event_time = std::min(
            next_event_time,
            std::chrono::steady_clock::time_point::clock::now() +
                std::chrono::milliseconds(
                    static_cast<int>(std::trunc(1000000.0 / frame_rate))));
      }
      next_flutter_event_time =
          std::max(next_flutter_event_time, next_event_time);
    }
  }
}
