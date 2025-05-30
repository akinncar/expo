// Copyright 2015-present 650 Industries. All rights reserved.

#import <EXDevMenu/DevMenuRCTBridge.h>

#import <EXDevMenu/DevClientNoOpLoadingView.h>
#import <EXDevMenu/DevMenuRCTDevSettings.h>

// The search path for the Swift generated headers are different
// between use_frameworks and non_use_frameworks mode.
#if __has_include(<EXDevMenuInterface/EXDevMenuInterface-Swift.h>)
#import <EXDevMenuInterface/EXDevMenuInterface-Swift.h>
#else
#import <EXDevMenuInterface-Swift.h>
#endif
#if __has_include(<ExpoModulesCore/ExpoModulesCore-Swift.h>)
#import <ExpoModulesCore/ExpoModulesCore-Swift.h>
#else
#import <ExpoModulesCore-Swift.h>
#endif
#if __has_include(<EXDevMenu/EXDevMenu-Swift.h>)
#import <EXDevMenu/EXDevMenu-Swift.h>
#else
#import <EXDevMenu-Swift.h>
#endif
#import <RCTCxxBridge+Private.h>

#import <React/RCTPerformanceLogger.h>
#import <React/RCTDevSettings.h>
#import <React/RCTBridge+Private.h>
#import <React/RCTDevMenu.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTJSIExecutorRuntimeInstaller.h>
#if __has_include(<React_RCTAppDelegate/RCTAppSetupUtils.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <React_RCTAppDelegate/RCTAppSetupUtils.h>
#else
#import <React-RCTAppDelegate/RCTAppSetupUtils.h>
#endif
#if __has_include(<reacthermes/HermesExecutorFactory.h>)
#import <reacthermes/HermesExecutorFactory.h>
#endif



@implementation DevMenuRCTCxxBridge

- (instancetype)initWithParentBridge:(RCTBridge *)bridge
{
  if ((self = [super initWithParentBridge:bridge])) {
    RCTBridge *appBridge = DevMenuManager.shared.currentBridge;
    // reset the singleton `RCTBridge.currentBridge` to app bridge instance
    RCTBridge.currentBridge = appBridge != nil ? appBridge.batchedBridge : nil;
  }
  return self;
}

/**
 * Theoretically, we could overwrite the `RCTDevSettings` module by exporting our version through the bridge.
 * However, this won't work with the js remote debugging. For some reason, the RN needs to initialized remote tools very early. So it always uses the default module to do it.
 * When we export our module, it won't be used in the initialized phase. So the dev-menu will start with remote debug support.
 */
- (RCTDevSettings *)devSettings
{
  // uncomment below to enable fast refresh for development builds of DevMenu
  //  return super.devSettings;
  return nil;
}

- (RCTDevMenu *)devMenu
{
  return nil;
}

- (NSArray<Class> *)filterModuleList:(NSArray<Class> *)modules
{
  NSArray<NSString *> *allowedModules = @[
    @"RCT",
    @"ExpoBridgeModule",
    @"EXNativeModulesProxy",
    @"EXReactNativeEventEmitter",
    @"ExpoModulesCore",
    @"ViewManagerAdapter_",
    @"EXDevLauncherDevMenu"
  ];
  NSArray<Class> *filteredModuleList = [modules filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable clazz, NSDictionary<NSString *,id> * _Nullable bindings) {
    NSString* clazzName = NSStringFromClass(clazz);
    for (NSString *allowedModule in allowedModules) {
      if ([clazzName hasPrefix:allowedModule]) {
        return true;
      }
    }
    return false;
  }]];

  return filteredModuleList;
}

- (NSArray<RCTModuleData *> *)_initializeModules:(NSArray<Class> *)modules
                               withDispatchGroup:(dispatch_group_t)dispatchGroup
                                lazilyDiscovered:(BOOL)lazilyDiscovered
{
  NSArray<Class> *filteredModuleList = [self filterModuleList: modules];
  return [super _initializeModules:filteredModuleList withDispatchGroup:dispatchGroup lazilyDiscovered:lazilyDiscovered];
}

@end

@implementation DevMenuRCTBridge

- (Class)bridgeClass
{
  return [DevMenuRCTCxxBridge class];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
// This method is still used so we need to override it even if it's deprecated
- (void)reloadWithReason:(NSString *)reason {}
#pragma clang diagnostic pop

@end

@interface RCTAppDelegate ()

- (Class)getModuleClassFromName:(const char *)name;

@end

@interface DevClientReactNativeFactoryDelegate (DevMenuRCTAppDelegate)

@end

@implementation DevMenuReactNativeFactoryDelegate

- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate launchOptions:(NSDictionary *)launchOptions
{
  return [[DevMenuRCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
}

- (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge
{
  NSMutableArray<id<RCTBridgeModule>> *modules = [NSMutableArray new];
  [modules addObject:[[DevClientNoOpLoadingView alloc] init]];
  [modules addObject:[[DevMenuRCTDevSettings alloc] init]];

  return modules;
}

- (Class)getModuleClassFromName:(const char *)name {
  // Overrides DevLoadingView ("Connect to Metro to develop JavaScript") as no-op for dev menu
  if (strcmp(name, "DevLoadingView") == 0) {
    return [DevClientNoOpLoadingView class];
  }
  return [super getModuleClassFromName:name];
}

@end
