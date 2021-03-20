
Pod::Spec.new do |s|
  s.name             = 'SeekPreview'
  s.version          = '0.2.0'
  s.summary          = 'Attach a SeekPreview to a seekBar to show small preview images during the seek action.'

  s.description      = <<-DESC
This is just an utility to show previews on top of a UISlider when seeking on a video player.
                       DESC

  s.homepage         = 'https://github.com/Enricoza/SeekPreview'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Enricoza' => 'enricozannini93@gmail.com' }
  s.source           = { :git => 'https://github.com/Enricoza/SeekPreview.git', :tag => "v#{s.version}"}
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'SeekPreview/*.swift'
end
