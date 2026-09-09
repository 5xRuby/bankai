# frozen_string_literal: true

DatabaseRewinder.clean_all

module DatabaseRewinderCleanup
  def after_teardown
    super
    DatabaseRewinder.clean
  end
end

ActiveSupport::TestCase.include(DatabaseRewinderCleanup)
