package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.github.nitishk72.youtubeapi.youtubeapi.YoutubeApiPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    YoutubeApiPlugin.registerWith(registry.registrarFor("io.github.nitishk72.youtubeapi.youtubeapi.YoutubeApiPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
