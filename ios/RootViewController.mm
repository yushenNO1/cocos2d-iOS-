/****************************************************************************
 Copyright (c) 2013      cocos2d-x.org
 Copyright (c) 2013-2017 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "RootViewController.h"
#import "cocos2d.h"

#include "base/CCEvent.h"
#include "base/CCEventDispatcher.h"

@implementation RootViewController


static int yuIndex = 0;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self twoMe];
}

-(void)twoMe{
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    cocos2d::FileUtils::getInstance()->addSearchPath("Resource/");
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    self.eaglView = [CCEAGLView viewWithFrame: [[UIScreen mainScreen] bounds]
                                  pixelFormat: (__bridge NSString*)cocos2d::GLViewImpl::_pixelFormat
                                  depthFormat: cocos2d::GLViewImpl::_depthFormat
                           preserveBackbuffer: NO
                                   sharegroup: nil
                                multiSampling: NO
                              numberOfSamples: 0 ];
    
    // Enable or disable multiple touches
    [self.eaglView setMultipleTouchEnabled:NO];
    
    self.view = self.eaglView;
    
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)self.eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    
    cocos2d::EventListenerCustom*    m_listenerIdle;
    cocos2d::EventCustom customEndEvent("game_scene_close_event");
    m_listenerIdle = cocos2d::EventListenerCustom::create("game_scene_close_event", [=](cocos2d::EventCustom* event) {
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    cocos2d::Director::getInstance()->getEventDispatcher()
    ->addEventListenerWithFixedPriority(m_listenerIdle, 1);
    app->run();
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startFullScreen" object:nil];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

}
-(void)viewWillDisappear:(BOOL)animated{

}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
#ifdef __IPHONE_6_0
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    auto glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (__bridge CCEAGLView *)glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}


@end
