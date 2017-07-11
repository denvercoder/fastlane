# set_fastlane_output_dir.rb

module Fastlane
  module Actions
    class SetupFastlaneOutputDirectory < Action
      USED_ENV_NAMES = [
        "BACKUP_XCARCHIVE_DESTINATION",
        "DERIVED_DATA_PATH",
        "FL_CARTHAGE_DERIVED_DATA",
        "FL_SLATHER_BUILD_DIRECTORY",
        "GYM_BUILD_PATH",
        "GYM_CODE_SIGNING_IDENTITY",
        "GYM_DERIVED_DATA_PATH",
        "GYM_OUTPUT_DIRECTORY",
        "GYM_RESULT_BUNDLE",
        "SCAN_DERIVED_DATA_PATH",
        "SCAN_OUTPUT_DIRECTORY",
        "SCAN_RESULT_BUNDLE",
        "XCODE_DERIVED_DATA_PATH"
      ].freeze

        # Print table
        FastlaneCore::PrintTable.print_values(
          config: params,
          title: "Summary for Setting fastlane output directory"
        )

        # Set output directory
        if params[:fastlane_output_dir]
          output_directory_path = File.expand_path(params[:fastlane_output_dir])
          UI.message "Set output directory path to: \"#{output_directory_path}\"."
          ENV['GYM_BUILD_PATH'] = output_directory_path
          ENV['GYM_OUTPUT_DIRECTORY'] = output_directory_path
          ENV['SCAN_OUTPUT_DIRECTORY'] = output_directory_path
          ENV['BACKUP_XCARCHIVE_DESTINATION'] = output_directory_path
        end

        # Set derived data
        if params[:derived_data_path]
          derived_data_path = File.expand_path(params[:derived_data_path])
          UI.message "Set derived data path to: \"#{derived_data_path}\"."
          ENV['DERIVED_DATA_PATH'] = derived_data_path # Used by clear_derived_data.
          ENV['XCODE_DERIVED_DATA_PATH'] = derived_data_path
          ENV['GYM_DERIVED_DATA_PATH'] = derived_data_path
          ENV['SCAN_DERIVED_DATA_PATH'] = derived_data_path
          ENV['FL_CARTHAGE_DERIVED_DATA'] = derived_data_path
          ENV['FL_SLATHER_BUILD_DIRECTORY'] = derived_data_path
        end

        # Set result bundle
        if params[:result_bundle]
          UI.message "Set result bundle."
          ENV['GYM_RESULT_BUNDLE'] = "YES"
          ENV['SCAN_RESULT_BUNDLE'] = "YES"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Set an output directory for build artifacts"
      end

      def self.details
        [
          "- Allows user to specify a preferred output directory",
          "- Sets output directory to './output' (gym, scan and backup_xcarchive).",
          "- Sets derived data path to './derivedData' (xcodebuild, gym, scan and clear_derived_data, carthage).",
          "- Produce result bundle (gym and scan).",
          "",
          "Creates own derived data for each job. All build results like IPA files and archives will be stored in the `./output` directory."
        ].join("\n")
      end

      def self.available_options
        [
          # Xcode parameters
          FastlaneCore::ConfigItem.new(key: :fastlane_output_dir,
                                       env_name: "FL_SETUP_OUTPUT_DIR",
                                       description: "The directory in which the ipa file should be stored in",
                                       is_string: true,
                                       default_value: "./output"),
          FastlaneCore::ConfigItem.new(key: :derived_data_path,
                                       env_name: "FL_SETUP_DERIVED_DATA_PATH",
                                       description: "The directory where built products and other derived data will go",
                                       is_string: true,
                                       default_value: "./derivedData"),
          FastlaneCore::ConfigItem.new(key: :result_bundle,
                                       env_name: "FL_SETUP_RESULT_BUNDLE",
                                       description: "Produce the result bundle describing what occurred will be placed",
                                       is_string: false,
                                       default_value: true)
        ]
      end

      def self.authors
        ["bartoszj", "denvercoder"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.example_code
        [
          'set_fastlane_output_dir'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
