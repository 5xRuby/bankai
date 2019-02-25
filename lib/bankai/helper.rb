module Bankai
  module Generators
    # :nodoc:
    module Helper
      protected

      def pg?
        gemfile.match?(/gem .pg./)
      end

      def mysql?
        gemfile.match?(/gem .mysql2./)
      end

      def capistrano?
        gemfile.match?(/gem .capistrano./)
      end

      private

      def gemfile
        @gemfile ||= File.read(destination_root + '/Gemfile')
      end
    end
  end
end
