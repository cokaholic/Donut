Pod::Spec.new do |s|
  s.name             = 'Donut'
  s.version          = '1.0.0'
  s.summary          = 'Donut is a library for arranging views circularly like a donut.'

  s.description      = <<-DESC
Donut is a library for arranging views circularly like a donut.

You can use it so easily, and it will be a wonderful experience for you.

This library is inspired by EMCarousel.
                       DESC

  s.homepage         = 'https://github.com/cokaholic/Donut'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Keisuke Tatsumi' => 'nietzsche.god.is.dead@gmail.com' }
  s.source           = { :git => 'https://github.com/cokaholic/Donut.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TK_u_nya'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Donut/**/*'
end
