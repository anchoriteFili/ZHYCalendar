Pod::Spec.new do |s|
    s.name         = 'ZHYCalendar'
    s.version      = '0.0.1'
    s.summary      = 'An useful tool'
    s.homepage     = 'https://github.com/anchoriteFili/ZHYCalendar'
    s.license      = 'MIT'
    s.authors      = {'zhaohongya' => '243097674@qq.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://github.com/anchoriteFili/ZHYCalendar.git', :tag => s.version}
    s.source_files = 'Source/**/**/**'
    s.requires_arc = true
end