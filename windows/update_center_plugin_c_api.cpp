#include "include/update_center/update_center_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "update_center_plugin.h"

void UpdateCenterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  update_center::UpdateCenterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
