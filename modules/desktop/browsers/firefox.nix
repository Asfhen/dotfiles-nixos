{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
    profileName = mkOpt types.str config.user.name;

    settings = mkOpt' (attrsOf (oneOf [ bool int str ])) {} ''
      Firefox preferences to set in <filename>user.js</filename>
    '';
    extraConfig = mkOpt' lines "" ''
      Extra lines to add to <filename>user.js</filename>
    '';

    userChrome  = mkOpt' lines "" "CSS Styles for Firefox's interface";
    userContent = mkOpt' lines "" "Global CSS Styles for websites";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.firefox-bin
        (makeDesktopItem {
          name = "firefox-private";
          desktopName = "Firefox (Private)";
          genericName = "Open a private Firefox window";
          icon = "firefox";
          exec = "${unstable.firefox-bin}/bin/firefox --private-window";
          categories = [ "Network" ];
        })
      ];

      # Prevent auto-creation of ~/Desktop. The trailing slash is necessary; see
      env.XDG_DESKTOP_DIR = "$HOME/";

      modules.desktop.browsers.firefox.settings = {
        # Default to dark theme in DevTools panel
        "devtools.theme" = "dark";
        # Enable ETP for decent security (makes firefox containers and many
        # common security/privacy add-ons redundant).
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.purge_trackers.enabled" = true;
        # Your customized toolbar settings are stored in
        # 'browser.uiCustomization.state'. This tells firefox to sync it between
        # machines. WARNING: This may not work across OSes. Since I use NixOS on
        # all the machines I use Firefox on, this is no concern to me.
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        # Enable userContent.css and userChrome.css for our theme modules
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Stop creating ~/Downloads!
        "browser.download.dir" = "${config.user.home}/downloads";
        # Don't use the built-in password manager. A nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Firefox is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Disable the "new tab page" feature and show a blank tab instead
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        # Disable Activity Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Firefox won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true;       # "Looks like you haven't started Firefox in a while."
        "browser.onboarding.enabled" = false;      # "New to Firefox? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "reader.parse-on-load.enabled" = false;  # "reader view"

        # Security-oriented defaults
        "security.family_safety.mode" = 0;
        "security.pki.sha1_enforcement_level" = 1;
        "security.tls.enable_0rtt_data" = false;
        # Use Mozilla geolocation service instead of Google if given permission
        "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false;  # uses Google Analytics
        "browser.discovery.enabled" = false;
        # Reduce File IO / SSD abuse
        # Otherwise, Firefox bombards the HD with writes. Not so nice for SSDs.
        # This forces it to write every 30 minutes, rather than 15 seconds.
        "browser.sessionstore.interval" = "1800000";
        # Disable battery API
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        # Disable health reports (basically more telemetry)
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;  # don't submit backlogged reports

        # Disable Form autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
      };

      # Use a stable profile name so we can target it in themes
      home.file = let cfgPath = ".mozilla/firefox"; in {
        "${cfgPath}/profiles.ini".text = ''
          [Profile0]
          Name=default
          IsRelative=1
          Path=${cfg.profileName}.default
          Default=1

          [General]
          StartWithLastProfile=1
          Version=2
        '';

        "${cfgPath}/${cfg.profileName}.default/user.js" =
          mkIf (cfg.settings != {} || cfg.extraConfig != "") {
            text = ''
              ${concatStrings (mapAttrsToList (name: value: ''
                user_pref("${name}", ${builtins.toJSON value});
              '') cfg.settings)}
              ${cfg.extraConfig}
            '';
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userChrome.css" =
          mkIf (cfg.userChrome != "") {
            text = cfg.userChrome;
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userContent.css" =
          mkIf (cfg.userContent != "") {
            text = cfg.userContent;
          };
      };
    }
  ]);
}