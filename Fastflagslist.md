# Ultimate Fast Flags List

Source: https://blxstrp.com/fast-flags-list/ (combined with curated list)

---

## Rendering API

### Metal
```json
{ "FFlagDebugGraphicsPreferMetal": "True" }
```

### Vulkan
```json
{ "FFlagDebugGraphicsDisableDirect3D11": "True", "FFlagDebugGraphicsPreferVulkan": "True" }
```

### OpenGL
```json
{ "FFlagDebugGraphicsDisableDirect3D11": "True", "FFlagDebugGraphicsPreferOpenGL": "True" }
```

### Direct X 10
```json
{ "FFlagDebugGraphicsPreferD3D11FL10": "True" }
```

### Direct X 11
```json
{ "FFlagDebugGraphicsPreferD3D11": "True" }
```

---

## Graphical Settings

### Smoother Terrain
```json
{ "FFlagDebugRenderingSetDeterministic": "True" }
```

### Graphics Quality Level
```json
{ "FIntRomarkStartWithGraphicQualityLevel": "1" }
```

### Low Quality Terrain Textures
```json
{ "FIntTerrainArraySliceSize": "4" }
```

### Disable Shadows
```json
{ "FIntRenderShadowIntensity": "0" }
```

### Set FPS Limit
```json
{ "DFIntTaskSchedulerTargetFps": "9999" }
```

### Enables Network Debug Tracker menu (CTRL+F8)
```json
{ "DFFlagDebugEnableInterpolationVisualizer": "True" }
```

### Humanoid Outline
```json
{ "DFFlagDebugDrawBroadPhaseAABBs": "True" }
```

### Buggy ZPlane Camera (a.k.a xray)
```json
{ "FIntCameraFarZPlane": "1" }
```

### Preserve rendering quality with display setting
```json
{ "DFFlagDisableDPIScale": "True" }
```

### Low Graphics Quality w/ Max Render Distance
```json
{ "DFIntDebugFRMQualityLevelOverride": "1" }
```

### Low Render Distance
```json
{ "DFIntDebugRestrictGCDistance": "1" }
```

### Disable Wind
```json
{ "FFlagGlobalWindRendering": "False", "FFlagGlobalWindActivated": "False" }
```

### Limits light updates
```json
{ "FIntRenderLocalLightUpdatesMax": "8", "FIntRenderLocalLightUpdatesMin": "6" }
```

### Disables fade in/out animation per light update (sets fade in ms to 0)
```json
{ "FIntRenderLocalLightFadeInMs": "0" }
```

### Makes avatars shiny (set FRM quality to 10 or above)
```json
{ "DFIntRenderClampRoughnessMax": "-640000000", "DFIntDebugFRMQualityLevelOverride": "21" }
```

### Disable PostFX
```json
{ "FFlagDisablePostFx": "True" }
```

### Pause Voxelizer / Disable Baked Shadows
```json
{ "DFFlagDebugPauseVoxelizer": "True" }
```

### Gray Sky
```json
{ "FFlagDebugSkyGray": "True" }
```

### Disable Player Shadows
```json
{ "FIntRenderShadowIntensity": "0" }
```

### Force LOD on Meshes
```json
{ "DFIntCSGLevelOfDetailSwitchingDistance": "0", "FFlagGlobaDFIntCSGLevelOfDetailSwitchingDistanceL12lWindActivated": "0", "DFIntCSGLevelOfDetailSwitchingDistanceL23": "0", "DFIntCSGLevelOfDetailSwitchingDistanceL34": "0" }
```

### Lighting Attenuation
```json
{ "FFlagNewLightAttenuation": "True" }
```

### Enable GPULightCulling (combine with Lighting Attenuation)
```json
{ "FFlagFastGPULightCulling3": "True" }
```

### Frame Buffer (0: white screen, 1-3: laggy movement, 4: stable, better performance)
```json
{ "DFIntMaxFrameBufferSize": "4" }
```

### High Quality Textures (1-3)
```json
{ "DFFlagTextureQualityOverrideEnabled": "True", "DFIntTextureQualityOverride": "3" }
```

### Lower Quality Textures (1-3)
```json
{ "DFIntPerformanceControlTextureQualityBestUtility": "-1" }
```

### Remove Grass
```json
{ "FIntFRMMinGrassDistance": "0", "FIntFRMMaxGrassDistance": "0", "FIntRenderGrassDetailStrands": "0", "FIntRenderGrassHeightScaler": "0" }
```

### Force MSAA (0,1,2,4,8)
```json
{ "FIntDebugForceMSAASamples": "4" }
```

### ShadowMap Bias
```json
{ "FIntRenderShadowmapBias": "75" }
```

---

## User Interface

### No Transparency V4 Menu (2023)
```json
{ "FStringInGameMenuModernizationStickyBarForcedUserIds": "UserID" }
```

### Revert Old Report Menu
```json
{ "FStringReportAbuseMenuRoactForcedUserIds": "UserID_HERE", "FFlagEnableReportAbuseMenuRoactABTest2": "False", "FFlagEnableReportAbuseMenuRoact2": "False", "FFlagEnableReportAbuseMenuLayerOnV3": "False" }
```

### Custom MicroProfile Scale
```json
{ "DFIntMicroProfilerDpiScaleOverride": "100" }
```

### V1 Menu
```json
{ "FIntNewInGameMenuPercentRollout3": "10000" }
```

### Hides GUI
```json
{ "FFlagDebugAdornsDisabled": "True" }
```

### Don't Render UI
```json
{ "FFlagDebugDontRenderUI": "True" }
```

### Enable Audio Controller
```json
{ "FFlagTrackerLodControllerDebugUI": "True" }
```

### Disable Autocomplete
```json
{ "FFlagEnableCommandAutocomplete": "False" }
```

### Chrome UI TopBar
```json
{ "FFlagEnableInGameMenuChrome": "True" }
```

### Better Chrome UI TopBar
```json
{ "FFlagChromeBetaFeature": "True", "FFlagEnableChromePinnedChat": "True", "FFlagEnableInGameMenuChrome": "True", "FFlagEnableInGameMenuChromeABTest": "True", "FFlagEnableInGameMenuChromeSignalAPI": "True", "FFlagPlayerListChromePushdown": "True", "FFlagEnableChromeEscapeFix": "True", "FFlagEnableChromeMicShimmer": "True" }
```

### Chrome UI Topbar Removal
```json
{ "FFlagChromeBetaFeature": "False", "FFlagEnableChromePinnedChat": "False", "FFlagEnableInGameMenuChrome": "False", "FFlagEnableInGameMenuChromeABTest": "False", "FFlagEnableInGameMenuChromeSignalAPI": "False", "FFlagPlayerListChromePushdown": "False" }
```

### Disable Bubble Chat
```json
{ "FFlagEnableBubbleChatFromChatService": "False" }
```

### Disable Selfview
```json
{ "FFlagCoreGuiTypeSelfViewPresent": "False" }
```

### Remove VC Beta Badge
```json
{ "FFlagVoiceBetaBadge": "False", "FFlagTopBarUseNewBadge": "False", "FFlagEnableBetaBadgeLearnMore": "False", "FFlagBetaBadgeLearnMoreLinkFormview": "False", "FFlagControlBetaBadgeWithGuac": "False", "FStringVoiceBetaBadgeLearnMoreLink": "null" }
```

### Pin Chat on Chrome UI
```json
{ "FFlagEnableChromePinnedChat": "True" }
```

### Hide guis (replace ID_HERE with group ID)
```json
{ "DFIntCanHideGuiGroupId": "ID_HERE" }
```

### Disable Fullscreen Title Bar
```json
{ "FIntFullscreenTitleBarTriggerDelayMillis": "3600000" }
```

### Set Custom Font Size
```json
{ "FIntFontSizePadding": "1" }
```

---

## Textures

### No Textures
```json
{
    "FStringPartTexturePackTable2022": "{\"glass\":{\"ids\":[\"rbxassetid://9873284556\",\"rbxassetid://9438453972\"],\"color\":[254,254,254,7]}}",
    "FStringPartTexturePackTablePre2022": "{\"glass\":{\"ids\":[\"rbxassetid://7547304948\",\"rbxassetid://7546645118\"],\"color\":[254,254,254,7]}}",
    "FStringTerrainMaterialTable2022": "",
    "FStringTerrainMaterialTablePre2022": ""
}
```

---

## Physics

### Stick unanchored parts to you
```json
{ "DFIntSolidFloorPercentForceApplication": "-1000", "DFIntNonSolidFloorPercentForceApplication": "-5000" }
```

### Breaks glitches (wallhops, longjumps, headhitters)
```json
{ "DFFlagSimHumanoidPhysics": "True" }
```

### Max Raycast Distance
```json
{ "DFIntRaycastMaxDistance": "3" }
```

### Possible Super Jump
```json
{ "DFIntNewRunningBaseGravityReductionFactorHundredth": "1500" }
```

### Breaks movement on higher negative values
```json
{ "FIntPGSAngularDampingPermilPersecond": "-10000" }
```

### Adjusts movement (set to 0)
```json
{ "FIntPGSAngularDampingPermilPersecond": "0" }
```

### Fall quicker and ignore certain block designs
```json
{ "FFlagHumanoidOnlySetCollisionsOnStateChangeDefaultIsEnabled": "False", "FFlagHumanoidParallelFasterSetCollision": "True" }
```

### Gear Desync (prevents game loading)
```json
{ "DFIntDataSenderRate": "-1" }
```

### Fake Lag
```json
{ "DFIntS2PhysicsSenderRate": "1" }
```

### Ultimate desync flag
```json
{ "DFIntS2PhysicsSenderRate": "1", "FIntPGSAngularDampingPermilPersecond": "0" }
```

### Noclip 1 (adjust value to avoid falling through ground)
```json
{ "DFFlagAssemblyExtentsExpansionStudHundredth": "-50" }
```

### Noclip 2
```json
{ "FIntPGSPenetrationMarginMax": "2147483647", "FIntPGSPenetrationMarginMin": "2147483647" }
```

### Noclip Combo (adjust value to avoid falling through ground)
```json
{ "FIntPGSPenetrationMarginMax": "2147483647", "FIntPGSPenetrationMarginMin": "2147483647", "DFFlagAssemblyExtentsExpansionStudHundredth": "-50" }
```

### Teleportation (control unanchored parts)
```json
{ "FIntPGSPenetrationMarginMax": "-100000000", "FIntPGSPenetrationMarginMin": "-100000000" }
```

### Limited speed flag (works in some games like Phantom Forces)
```json
{ "DFIntDebugSimPhysicsSteppingMethodOverride": "10000000" }
```

### Hip Height (bounce with negative values, 0 for hover)
```json
{ "DFIntMaxAltitudePDStickHipHeightPercent": "-200" }
```

### Wallglide
```json
{ "DFFlagUnstickForceAttackInTenths": "-4" }
```

---

## Other FFlags

### Disable Ads
```json
{ "FFlagAdServiceEnabled": "False" }
```

### Disable Telemetry (does not fully disable)
```json
{ "FFlagDebugDisableTelemetryEphemeralCounter": "True", "FFlagDebugDisableTelemetryEphemeralStat": "True", "FFlagDebugDisableTelemetryEventIngest": "True", "FFlagDebugDisableTelemetryPoint": "True", "FFlagDebugDisableTelemetryV2Counter": "True", "FFlagDebugDisableTelemetryV2Event": "True", "FFlagDebugDisableTelemetryV2Stat": "True" }
```

### Scroll Speed
```json
{ "FIntScrollWheelDeltaAmount": "140" }
```

### Surf the web inside Roblox (click Beta or 13+ badge)
```json
{ "FFlagTopBarUseNewBadge": "True", "FStringTopBarBadgeLearnMoreLink": "https://google.com/", "FStringVoiceBetaBadgeLearnMoreLink": "https://google.com/" }
```

### Sounds use physical velocity and become distorted
```json
{ "FFlagSoundsUsePhysicalVelocity": "True" }
```

### Shows the state of a flag (example)
```json
{ "FStringDebugShowFlagState": "DFIntTaskSchedulerTargetFps, ChannelName" }
```

### MTU (may improve ping)
```json
{ "DFIntConnectionMTUSize": "MTU_HERE" }
```

### No Internet Disconnect (kick still happens, message hidden)
```json
{ "DFFlagDebugDisableTimeoutDisconnect": "True" }
```

### Quick Game Launch (buggy)
```json
{ "FFlagEnableQuickGameLaunch": "True" }
```

### Voice chat distance (default: min 7, max 80)
```json
{ "DFIntVoiceChatRollOffMinDistance": "7", "DFIntVoiceChatRollOffMaxDistance": "80" }
```

### Disable In-Game Purchases
```json
{ "DFFlagOrder66": "True" }
```

### Disable Chat
```json
{ "FFlagDebugForceChatDisabled": "True" }
```

### Limit audios being played
```json
{ "DFIntMaxLoadableAudioChannelCount": "1" }
```

### Adds UI highlighting touched parts (blue circle on humanoid)
```json
{ "FFlagDebugHumanoidRendering": "True" }
```

### Custom Disconnect Message
```json
{ "FFlagReconnectDisabled": "True", "FStringReconnectDisabledReason": "You're stupid and I hate you" }
```

### Display FPS
```json
{ "FFlagDebugDisplayFPS": "True" }
```

### Verified Badge (replace UserID_HERE)
```json
{ "FStringWhitelistVerifiedUserId": "UserID_HERE" }
```

### Verified Badge on everyone
```json
{ "FFlagOverridePlayerVerifiedBadge": "True" }
```

### Applies cool colors to stuff
```json
{ "FFlagDebugDisplayUnthemedInstances": "True" }
```

### Show Outlined Chunks
```json
{ "FFlagDebugLightGridShowChunks": "True" }
```

### Remove Disconnect Blur / Loading Blur
```json
{ "FIntRobloxGuiBlurIntensity": "0" }
```

### Disable Dynamic Heads Animations
```json
{ "DFFlagEnableDynamicHeadByDefault": "False" }
```

### Failsafe humanoid (gray avatars)
```json
{ "FFlagFailsafeHumanoid_3": "True" }
```

### Automatically unmute mic on join
```json
{ "FFlagDebugDefaultChannelStartMuted": "False" }
```

### Overlay that shows what you type
```json
{ "FFlagDebugTextBoxServiceShowOverlay": "True" }
```

### Opt-out Experience Language (removes setting)
```json
{ "FIntV1MenuLanguageSelectionFeaturePerMillageRollout": "0" }
```

### Disable New Chat Translation Settings
```json
{ "FFlagChatTranslationSettingEnabled3": "False" }
```

### Infinite zoom out
```json
{ "FIntCameraMaxZoomDistance": "9999" }
```

### Limits number of animations being played
```json
{ "DFIntMaxActiveAnimationTracks": "0" }
```

### Prevents Remote Events from running
```json
{ "DFIntRemoteEventSingleInvocationSizeLimit": "1" }
```

### Clientsided Invisible
```json
{ "FIntParallelDynamicPartsFastClusterBatchSize": "1" }
```

---

## Patched (no longer functional)

```
DFIntFreeFallBalanceP
DFIntFreeFallOrientationP
DFIntGettingUpBalanceD
DFIntGettingUpBalanceP
DFIntLandedBalanceD
DFIntLandedBalanceP
DFIntNewRunningBaseAltitudeD
DFIntNewRunningBaseAltitudeP
DFIntRunningBaseAltitudeD
DFIntRunningBaseAltitudeP
DFIntRunningBaseOrientationP
FFlagDebugSimIntegrationStabilityTesting
FFlagSimIslandizerManager
```

---

## Performance / Optimization Flags (from Bloxstrap)

These flags are commonly used to improve performance, reduce latency, and tweak network behavior.

```json
{
  "FLogNetwork": "7",
  "FFlagHandleAltEnterFullscreenManually": "False",
  "FFlagAdServiceEnabled": "False",
  "DFIntOcclusionShelfScalarNumerator": "2",
  "DFFlagFastEndUpdateLoop": "True",
  "FFlagFRMRefactor": "False",
  "FFlagFixSensitivityTextPrecision": "False",
  "DFIntWaitOnUpdateNetworkLoopEndedMS": "100",
  "FFlagUISUseLastFrameTimeInUpdateInputSignal": "True",
  "FFlagSimEnableDCD16": "True",
  "FFlagDebugNextGenReplicatorEnabledWriteCFrameColor": "True",
  "DFFlagFrameTimeJitterMedians2": "False",
  "DFFlagReplicatorSeparateVarThresholds": "True",
  "FFlagFasterPreciseTime4": "True",
  "DFFlagTeleportClientAssetPreloadingDoingExperiment2": "True",
  "FIntActivatedCountTimerMSKeyboard": "0",
  "FIntDebugForceMSAASamples": "1",
  "DFIntNetworkClusterPacketCacheNumParallelTasks": "12",
  "FFlagLargeReplicatorRead2": "True",
  "FFlagPreComputeAcceleratorArrayForSharingTimeCurve": "True",
  "DFIntMegaReplicatorNumParallelTasks": "12",
  "FFlagUserBetterInertialScrolling": "True",
  "DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs": "25",
  "DFIntGraphicsOptimizationModeMinFrameTimeTargetMs": "16",
  "DFIntCodecMaxOutgoingFrames": "1000",
  "FFlagDebugDisableTelemetryV2Stat": "True",
  "FFlagDebugDisableTelemetryV2Counter": "True",
  "DFFlagNextGenRepRollbackOverbudgetPackets": "True",
  "FStringTerrainMaterialTable2022": "",
  "FStringVoiceBetaBadgeLearnMoreLink": "null",
  "DFIntTaskSchedulerJobInitThreads": "12",
  "FFlagChatTranslationEnableSystemMessage": "False",
  "DFIntS2PhysicsSenderRate": "128"
}
```