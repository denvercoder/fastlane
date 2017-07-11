describe Fastlane do
  describe Fastlane::FastFile do
    describe "Setup Output Directory" do
      before :each do
        # Clean all used environment variables
        Fastlane::Actions::SetupFastlaneOutputDirectory::USED_ENV_NAMES + Fastlane::Actions::SetupFastlaneOutputDirectory.available_options.map(&:env_name).each do |key|
          ENV.delete(key)
        end
      end

        it "set output directory" do
          Fastlane::FastFile.new.parse("lane :test do
            set_fastlane_output_dir(
              output_directory: '/tmp/output/directory'
            )
          end").runner.execute(:test)

          expect(ENV["BACKUP_XCARCHIVE_DESTINATION"]).to eq("/tmp/output/directory")
          expect(ENV["GYM_BUILD_PATH"]).to eq("/tmp/output/directory")
          expect(ENV["GYM_OUTPUT_DIRECTORY"]).to eq("/tmp/output/directory")
          expect(ENV["SCAN_OUTPUT_DIRECTORY"]).to eq("/tmp/output/directory")
        end

        it "set derived data" do
          Fastlane::FastFile.new.parse("lane :test do
            set_fastlane_output_dir(
              derived_data_path: '/tmp/derived_data'
            )
          end").runner.execute(:test)

          expect(ENV["DERIVED_DATA_PATH"]).to eq("/tmp/derived_data")
          expect(ENV["FL_CARTHAGE_DERIVED_DATA"]).to eq("/tmp/derived_data")
          expect(ENV["FL_SLATHER_BUILD_DIRECTORY"]).to eq("/tmp/derived_data")
          expect(ENV["GYM_DERIVED_DATA_PATH"]).to eq("/tmp/derived_data")
          expect(ENV["SCAN_DERIVED_DATA_PATH"]).to eq("/tmp/derived_data")
          expect(ENV["XCODE_DERIVED_DATA_PATH"]).to eq("/tmp/derived_data")
        end

        it "disable result bundle path" do
          Fastlane::FastFile.new.parse("lane :test do
            set_fastlane_output_dir(
              result_bundle: false
            )
          end").runner.execute(:test)

          expect(ENV["GYM_RESULT_BUNDLE"]).to be_nil
          expect(ENV["SCAN_RESULT_BUNDLE"]).to be_nil
        end
      end

      after :all do
        # Clean all used environment variables
        Fastlane::Actions::SetupFastlaneOutputDirectory::USED_ENV_NAMES + Fastlane::Actions::SetupFastlaneOutputDirectory.available_options.map(&:env_name).each do |key|
          ENV.delete(key)
        end
      end
    end
  end
end
