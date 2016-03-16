
Pod::Spec.new do |s|
    s.name         = "AutomaticInfiniteLoopView"
    s.version      = "1.0.0"
    s.summary      = "自定义布局，自动循环滚动"

    s.description  = <<-DESC
                        自动循环滚动图片、文本，复用自定义的布局，
                   DESC

    s.homepage     = "https://github.com/LiYouCheng/AutomaticInfiniteLoopView"
    s.license      = "MIT"
    s.author             = { "李游城" => "542235666@qq.com" }
    s.source       = { :git => "https://github.com/LiYouCheng/AutomaticInfiniteLoopView.git", :tag => "1.0.0" }
    s.platform     = :ios, "7.0"
    s.requires_arc = true
    s.source_files  = 'AutomaticInfiniteLoopView/*'

  # s.framework  = "SomeFramework"

end
