# All custom scripts (this world, client dump)

Client methods have decompiled bodies in `catalog/<Logic>.lua`.
Server-only methods are empty on the client; signatures come from Lua debug locvars.

| Logic | Method | Arguments | Side | Lines |
|---|---|---|---|---|
| `AdminCommandLogic` | `abuseLogoutDropUseItemTest` | `self, user, argc, args` | server-only | 1-36 |
| `AdminCommandLogic` | `abuseLogoutDropUseItemTestClient` | `self, delayMs, useSlot` | client | 1-11 |
| `AdminCommandLogic` | `abuseLogoutScrollTest` | `self, user, argc, args` | server-only | 1-82 |
| `AdminCommandLogic` | `abuseLogoutScrollTestClient` | `self, delayMs, scrollItemId, useSlot, targetSlot` | client | 1-11 |
| `AdminCommandLogic` | `addPeriodTestStackToInventory` | `self, user, itemID, invType, seconds, addTradeCashFlag` | server-only | 1-55 |
| `AdminCommandLogic` | `advanceJobPathForJobTestSetup` | `self, player, jobId, targetLevel` | server-only | 1-47 |
| `AdminCommandLogic` | `appendJobTestConsumableItem` | `self, items, itemId, count` | server-only | 1-11 |
| `AdminCommandLogic` | `appendJobTestEquipItem` | `self, items, itemId` | server-only | 1-11 |
| `AdminCommandLogic` | `appendJobTestProjectileItems` | `self, items, jobId` | server-only | 1-21 |
| `AdminCommandLogic` | `applyAdminHideAlphaClient` | `self, user, enabled` | client | 1-25 |
| `AdminCommandLogic` | `applyDebuff` | `self, user, argc, args` | server-only | 1-18 |
| `AdminCommandLogic` | `applyJobTestSetup` | `self, user, argc, args` | server-only | 1-38 |
| `AdminCommandLogic` | `attractTest` | `self, user, argc, args` | server-only | 1-15 |
| `AdminCommandLogic` | `bowExpertPadTest` | `self, user, argc, args` | server-only | 1-31 |
| `AdminCommandLogic` | `buildCubeVerifyCompactRateString` | `self, countMap, successCount` | server-only | 1-22 |
| `AdminCommandLogic` | `buildJobTestBasicEquipItems` | `self, jobId, targetLevel, fallbackItems` | server-only | 1-36 |
| `AdminCommandLogic` | `buildSkillJobPath` | `self, id` | client | 1-29 |
| `AdminCommandLogic` | `centerNotice` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `centerNoticeClient` | `self, user, text` | client | 1-3 |
| `AdminCommandLogic` | `changeJob` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `changeLevel` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `changeSkillLevel` | `self, user, argc, args` | server-only | 1-16 |
| `AdminCommandLogic` | `checkMobTime` | `self, user, argc, args` | server-only | 1-24 |
| `AdminCommandLogic` | `cleanupPreviousJobTestGrantedItems` | `self, user` | server-only | 1-16 |
| `AdminCommandLogic` | `clearAllSkills` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `clearCrashTestMemory` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `clearCrashTestTimers` | `self, user, argc, args` | server-only | 1-17 |
| `AdminCommandLogic` | `clearDiseaseImmune` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `clearDrops` | `self, user` | server-only | 1-12 |
| `AdminCommandLogic` | `clearFixedDamageCheat` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `clearGodMode` | `self, user, argc, args` | server-only | 1-11 |
| `AdminCommandLogic` | `clearItems` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `clearQuestMobCount` | `self, user, argc, args` | server-only | 1-15 |
| `AdminCommandLogic` | `completeShaolinEntryPrerequisites` | `self, user, argc, args` | server-only | 1-47 |
| `AdminCommandLogic` | `consumeAllPetFood` | `self, user, argc, args` | server-only | 1-75 |
| `AdminCommandLogic` | `countTable` | `self, values` | server-only | 1-11 |
| `AdminCommandLogic` | `crashTestCpuSpin` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `crashTestMemoryFlood` | `self, user, argc, args` | server-only | 1-19 |
| `AdminCommandLogic` | `crashTestStackOverflow` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `crashTestTimerFlood` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `createItem` | `self, user, argc, args` | server-only | 1-65 |
| `AdminCommandLogic` | `createPet` | `self, user, argc, args` | server-only | 1-29 |
| `AdminCommandLogic` | `crossbowExpertPadTest` | `self, user, argc, args` | server-only | 1-31 |
| `AdminCommandLogic` | `cubeVerify` | `self, user, argc, args` | server-only | 1-65 |
| `AdminCommandLogic` | `currentmap` | `self, user` | server-only | 1-7 |
| `AdminCommandLogic` | `debuffTest` | `self, user, argc, args` | server-only | 1-78 |
| `AdminCommandLogic` | `doSave` | `self, user` | server-only | 1-5 |
| `AdminCommandLogic` | `dropItem` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `dropItemServer` | `self, user, ItemId, Count` | server-only | 1-27 |
| `AdminCommandLogic` | `energyDispelTest` | `self, user, argc, args` | server-only | 1-34 |
| `AdminCommandLogic` | `executeLieDetector` | `self, user, argc, args` | server-only | 1-3 |
| `AdminCommandLogic` | `finalizeJobTestSetup` | `self, user` | server-only | 1-18 |
| `AdminCommandLogic` | `findCubeVerifyEquipItem` | `self, partKey, requestedReqLevel` | server-only | 1-43 |
| `AdminCommandLogic` | `findJobTestBestEquipItem` | `self, itemPrefix, jobGroup, targetLevel` | server-only | 1-40 |
| `AdminCommandLogic` | `findTimedRidingSkillCommandTarget` | `self, user, query` | server-only | 1-12 |
| `AdminCommandLogic` | `findUserByName` | `self, targetName` | server-only | 1-13 |
| `AdminCommandLogic` | `findUserByPlayerTag` | `self, playerTag` | server-only | 1-19 |
| `AdminCommandLogic` | `finishCubeVerifyPart` | `self, sessionId` | server-only | 1-81 |
| `AdminCommandLogic` | `fontChange` | `self, user, argc, args` | client | 1-7 |
| `AdminCommandLogic` | `fontChangeClient` | `self, user, useMSW` | client | 1-7 |
| `AdminCommandLogic` | `forceDetectMacro` | `self, user, argc, args` | server-only | 1-22 |
| `AdminCommandLogic` | `forceExecuteLieDetector` | `self, user, argc, args` | server-only | 1-31 |
| `AdminCommandLogic` | `formatCubeVerifyRate` | `self, rate` | server-only | 1-9 |
| `AdminCommandLogic` | `formatDetectMacroDuration` | `self, seconds` | server-only | 1-14 |
| `AdminCommandLogic` | `formatFieldLog` | `self, fieldLog` | server-only | 1-37 |
| `AdminCommandLogic` | `fwdebug` | `self, user, argc, args` | server-only | 1-83 |
| `AdminCommandLogic` | `getCubeVerifyGradeLabelByValue` | `self, grade` | server-only | 1-15 |
| `AdminCommandLogic` | `getCubeVerifyParts` | `self` | server-only | 1-19 |
| `AdminCommandLogic` | `getCubeVerifyPotentialText` | `self, cubeItemId, optionId, reqLevel` | server-only | 1-26 |
| `AdminCommandLogic` | `getDetectMacroLastPassText` | `self, target` | server-only | 1-17 |
| `AdminCommandLogic` | `getJobTestEquipJobGroup` | `self, jobId` | server-only | 1-7 |
| `AdminCommandLogic` | `getJobTestGrantedItemStore` | `self` | server-only | 1-6 |
| `AdminCommandLogic` | `getJobTestInventoryItemCount` | `self, user, itemID` | server-only | 1-6 |
| `AdminCommandLogic` | `getJobTestWeaponPrefixes` | `self, jobId` | server-only | 1-26 |
| `AdminCommandLogic` | `getMacroProbability` | `self, user, argc, args` | server-only | 1-3 |
| `AdminCommandLogic` | `getProjectileSkillTestSpecs` | `self` | client | 1-29 |
| `AdminCommandLogic` | `getQuestData` | `self, user, argc, args` | server-only | 1-7 |
| `AdminCommandLogic` | `giveJobBasicItemsForJobTestSetup` | `self, user, items` | server-only | 1-36 |
| `AdminCommandLogic` | `giveTimedRidingSkillByUnit` | `self, user, argc, args, unit` | server-only | 1-42 |
| `AdminCommandLogic` | `giveTimedRidingSkillDays` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `giveTimedRidingSkillHours` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `giveTimedRidingSkillMinutes` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `giveTimedRidingSkillSeconds` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `grantJobTestItemForJobTestSetup` | `self, user, itemID, count` | server-only | 1-37 |
| `AdminCommandLogic` | `hideChatBalloonsForFontRerenderClient` | `self` | client | 1-61 |
| `AdminCommandLogic` | `instanceStatus` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `inviteParty` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `isCubeVerifyItemMatchPart` | `self, itemId, partKey` | server-only | 1-19 |
| `AdminCommandLogic` | `isCubeVerifyPartAlias` | `self, partKey, value` | server-only | 1-29 |
| `AdminCommandLogic` | `isJobTestEquipReqJobAllowed` | `self, reqJob, jobGroup` | server-only | 1-9 |
| `AdminCommandLogic` | `isJobTestProjectileItemForJob` | `self, itemId, jobId` | server-only | 1-12 |
| `AdminCommandLogic` | `item` | `self, user, argc, args` | server-only | 1-40 |
| `AdminCommandLogic` | `kickUser` | `self, user, argc, args` | server-only | 1-20 |
| `AdminCommandLogic` | `killAll` | `self, user` | server-only | 1-16 |
| `AdminCommandLogic` | `killAllDrop` | `self, user` | server-only | 1-15 |
| `AdminCommandLogic` | `levelToForJobTestSetup` | `self, player, targetLevel` | server-only | 1-6 |
| `AdminCommandLogic` | `levelUp` | `self, user` | server-only | 1-3 |
| `AdminCommandLogic` | `logCubeVerifyRecord` | `self, payload` | server-only | 1-10 |
| `AdminCommandLogic` | `maplePoint` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `masterAllSkills` | `self, user, argc, args` | server-only | 1-38 |
| `AdminCommandLogic` | `masterJobSkillsForJobTestSetup` | `self, user, jobId` | server-only | 1-31 |
| `AdminCommandLogic` | `megaphone` | `self, user, argc, args` | server-only | 1-22 |
| `AdminCommandLogic` | `mindControl` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `miracleCube` | `self, user` | server-only | 1-3 |
| `AdminCommandLogic` | `mobBuffDebuff` | `self, user, argc, args` | server-only | 1-80 |
| `AdminCommandLogic` | `mobSkillSpawnTest` | `self, user, argc, args` | server-only | 1-51 |
| `AdminCommandLogic` | `OnBeginPlay` | `self` | server-only | 1-213 |
| `AdminCommandLogic` | `parseCubeVerifyCube` | `self, cubeArg` | server-only | 1-10 |
| `AdminCommandLogic` | `parseCubeVerifyGrade` | `self, gradeArg` | server-only | 1-13 |
| `AdminCommandLogic` | `pinkbean` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `popup` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `position` | `self, user` | server-only | 1-5 |
| `AdminCommandLogic` | `positioncheck` | `self, user, argc, args` | server-only | 1-5 |
| `AdminCommandLogic` | `prepareShaolinQuest62007TestData` | `self, user, argc, args` | server-only | 1-65 |
| `AdminCommandLogic` | `prepareShaolinQuest62011TestData` | `self, user, argc, args` | server-only | 1-51 |
| `AdminCommandLogic` | `projectileSkillTestSet` | `self, user, argc, args` | server-only | 1-23 |
| `AdminCommandLogic` | `randomBiasTest` | `self, user, argc, args` | server-only | 1-119 |
| `AdminCommandLogic` | `reconnectPlayerForChannelTransferReproduction` | `self, userId, playerId, retryCount` | server-only | 1-27 |
| `AdminCommandLogic` | `recordUserAllInstance` | `self, user, argc, args` | server-only | 1-37 |
| `AdminCommandLogic` | `recordUserHistory` | `self, user, argc, args` | server-only | 1-11 |
| `AdminCommandLogic` | `removeJobTestGrantedConsumables` | `self, user, consumables` | server-only | 1-17 |
| `AdminCommandLogic` | `removeJobTestGrantedConsumableSlots` | `self, user, consumableSlots` | server-only | 1-21 |
| `AdminCommandLogic` | `removeJobTestGrantedEquippedItems` | `self, user, equipUlids` | server-only | 1-23 |
| `AdminCommandLogic` | `removeJobTestGrantedEquips` | `self, user, equipUlids` | server-only | 1-7 |
| `AdminCommandLogic` | `removeJobTestGrantedInventoryEquips` | `self, user, equipUlids` | server-only | 1-25 |
| `AdminCommandLogic` | `reproduceChannelTransfer` | `self, user, argc, args` | server-only | 1-25 |
| `AdminCommandLogic` | `reproduceExpeditionWorldTransfer` | `self, user, argc, args` | server-only | 1-72 |
| `AdminCommandLogic` | `rerenderAllBitmapFontsClient` | `self, useMSW` | client | 1-45 |
| `AdminCommandLogic` | `resetAllSkillCooldowns` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `resetAllSkillCooldownsClient` | `self, user` | client | 1-9 |
| `AdminCommandLogic` | `resetAranPassClaimState` | `self, user, argc, args` | server-only | 1-27 |
| `AdminCommandLogic` | `resetBaseCharacterForJobTestSetup` | `self, user` | server-only | 1-22 |
| `AdminCommandLogic` | `resetBlizzardMasteryBookTest` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `resetFieldSet` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `resetGuildSkillInvestCounts` | `self, user, argc, args` | server-only | 1-13 |
| `AdminCommandLogic` | `resetMap` | `self, user, argc, args` | server-only | 1-7 |
| `AdminCommandLogic` | `resetShaolinChiefPriestWeeklyEntryTestData` | `self, user, argc, args` | server-only | 1-28 |
| `AdminCommandLogic` | `resetShaolinMartialMonkEntryTestData` | `self, user, argc, args` | server-only | 1-32 |
| `AdminCommandLogic` | `resetShaolinQuestTestData` | `self, user, argc, args` | server-only | 1-69 |
| `AdminCommandLogic` | `resolveCubeVerifyParts` | `self, partArg` | server-only | 1-13 |
| `AdminCommandLogic` | `resolveJobTestSetup` | `self, jobName` | server-only | 1-25 |
| `AdminCommandLogic` | `resolveSkillMaxLevel` | `self, skill` | client | 1-19 |
| `AdminCommandLogic` | `runCubeVerifyForPart` | `self, sessionId` | server-only | 1-94 |
| `AdminCommandLogic` | `runCubeVerifyPartBatch` | `self, sessionId` | server-only | 1-61 |
| `AdminCommandLogic` | `scrollNotice` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `search` | `self, user, argc, args` | server-only | 1-50 |
| `AdminCommandLogic` | `sendPeriodTestCountdown` | `self, userId, itemID, seconds, label` | server-only | 1-32 |
| `AdminCommandLogic` | `setAbility` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `setAranCombo` | `self, user, argc, args` | server-only | 1-27 |
| `AdminCommandLogic` | `setDebugMode` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `setDiseaseImmune` | `self, user, argc, args` | server-only | 1-13 |
| `AdminCommandLogic` | `setDojoGauge` | `self, user, argc, args` | server-only | 1-18 |
| `AdminCommandLogic` | `setEnableCollisionGizmo` | `self, user, enable` | client | 1-22 |
| `AdminCommandLogic` | `setEnableMobAttackHitbox` | `self, user, enable` | server-only | 1-24 |
| `AdminCommandLogic` | `setEnableMobHitbox` | `self, user, enable` | server-only | 1-25 |
| `AdminCommandLogic` | `setFixedDamageCheat` | `self, user, argc, args` | server-only | 1-16 |
| `AdminCommandLogic` | `setFixedDamageCheatClient` | `self, fixedDamage` | client | 1-9 |
| `AdminCommandLogic` | `setGodMode` | `self, user, argc, args` | server-only | 1-14 |
| `AdminCommandLogic` | `setGodModeClient` | `self, untilTime, enabled` | client | 1-9 |
| `AdminCommandLogic` | `setKeyValue` | `self, user, argc, args` | server-only | 1-22 |
| `AdminCommandLogic` | `setMacroProbability` | `self, user, argc, args` | server-only | 1-36 |
| `AdminCommandLogic` | `setMeso` | `self, user, argc, args` | server-only | 1-5 |
| `AdminCommandLogic` | `setMobCount` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `setMSWCody` | `self, user` | server-only | 1-3 |
| `AdminCommandLogic` | `setPlayerAbility` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `setPlayerKeyValue` | `self, user, argc, args` | server-only | 1-28 |
| `AdminCommandLogic` | `setQuestEx` | `self, user, argc, args` | server-only | 1-14 |
| `AdminCommandLogic` | `setQuestExUser` | `self, user, argc, args` | server-only | 1-22 |
| `AdminCommandLogic` | `showCubeVerifyUsage` | `self, user, detail` | server-only | 1-7 |
| `AdminCommandLogic` | `showEffect` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `showEffectToClient` | `self, user, path` | client | 1-11 |
| `AdminCommandLogic` | `showFieldLogs` | `self, user, argc, args` | server-only | 1-24 |
| `AdminCommandLogic` | `showGUIEffect` | `self, user, argc, args` | server-only | 1-3 |
| `AdminCommandLogic` | `showMapMetrics` | `self, user, argc, args` | server-only | 1-74 |
| `AdminCommandLogic` | `showMessage` | `self, user, argc, args` | server-only | 1-7 |
| `AdminCommandLogic` | `showResolutionText` | `self, user, argc, args` | server-only | 1-5 |
| `AdminCommandLogic` | `showTimedRidingSkillUsage` | `self, user, commandName` | server-only | 1-8 |
| `AdminCommandLogic` | `spawnAbyssMob` | `self, user, argc, args` | server-only | 1-44 |
| `AdminCommandLogic` | `spawnArrowDamageTestMob` | `self, user, argc, args` | server-only | 1-32 |
| `AdminCommandLogic` | `spawnCubeUI` | `self` | client | 1-5 |
| `AdminCommandLogic` | `spawnDummy` | `self, user, argc, args` | server-only | 1-60 |
| `AdminCommandLogic` | `spawnMob` | `self, user, argc, args` | server-only | 1-47 |
| `AdminCommandLogic` | `spawnMobClient` | `self, newMob` | client | 1-24 |
| `AdminCommandLogic` | `spawnNPC` | `self, user, argc, args` | server-only | 1-7 |
| `AdminCommandLogic` | `spawnReactor` | `self, user, argc, args` | server-only | 1-11 |
| `AdminCommandLogic` | `statTest` | `self, user, argc, args` | server-only | 1-22 |
| `AdminCommandLogic` | `stunTest` | `self, user, argc, args` | server-only | 1-13 |
| `AdminCommandLogic` | `summonTest` | `self, user, argc, args` | server-only | 1-34 |
| `AdminCommandLogic` | `teachSkillTestSet` | `self, user, specs, requestedLevel` | client | 1-32 |
| `AdminCommandLogic` | `test1` | `self, user, argc, args` | server-only | 1-26 |
| `AdminCommandLogic` | `test2` | `self` | server-only | 1-6 |
| `AdminCommandLogic` | `test3` | `self, user, argc, args` | server-only | 1-40 |
| `AdminCommandLogic` | `test3Client` | `self, user` | client | 1-43 |
| `AdminCommandLogic` | `test4` | `self, user, argc, args` | server-only | 1-34 |
| `AdminCommandLogic` | `test4_client` | `self, user` | server-only | 1-22 |
| `AdminCommandLogic` | `test5` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `test5_client` | `self, user, angle` | client | 1-188 |
| `AdminCommandLogic` | `testFadeYesNo` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `testFadeYesNoClient` | `self, message` | client | 1-9 |
| `AdminCommandLogic` | `testFieldSet` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `testMobDrop` | `self, user, argc, args` | server-only | 1-86 |
| `AdminCommandLogic` | `testPeriodLockerPointCoupon` | `self, user, argc, args` | server-only | 1-52 |
| `AdminCommandLogic` | `testPeriodPet` | `self, user, argc, args` | server-only | 1-10 |
| `AdminCommandLogic` | `testPeriodTradeCashItem` | `self, user, argc, args` | server-only | 1-17 |
| `AdminCommandLogic` | `testPeriodTradePetItem` | `self, user, argc, args` | server-only | 1-16 |
| `AdminCommandLogic` | `testscript` | `self, user, argc, args` | server-only | 1-12 |
| `AdminCommandLogic` | `testSkillEntryNil` | `self, user, argc, args` | server-only | 1-16 |
| `AdminCommandLogic` | `timer` | `self, sec` | client | 1-3 |
| `AdminCommandLogic` | `timerOverlapTest` | `self, user, argc, args` | server-only | 1-107 |
| `AdminCommandLogic` | `timerTest` | `self, user, argc, args` | server-only | 1-5 |
| `AdminCommandLogic` | `toggleAdminHide` | `self, user, argc, args` | server-only | 1-27 |
| `AdminCommandLogic` | `toggleBGM` | `self, user, argc, args` | server-only | 1-27 |
| `AdminCommandLogic` | `toggleMacroQuestionUI` | `self, user, argc, args` | server-only | 1-5 |
| `AdminCommandLogic` | `toggleMacroQuestionUIToClient` | `self, enable` | client | 1-13 |
| `AdminCommandLogic` | `toggleMobAttackHitbox` | `self, user, argc, args` | server-only | 1-8 |
| `AdminCommandLogic` | `toggleMobHitbox` | `self, user, argc, args` | client | 1-9 |
| `AdminCommandLogic` | `toggleObserveUI` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `toggleObserveUIToClient` | `self, enable` | client | 1-11 |
| `AdminCommandLogic` | `toggleresolutionText` | `self, user` | client | 1-7 |
| `AdminCommandLogic` | `toggleUserAttackLog` | `self, user, argc, args` | server-only | 1-29 |
| `AdminCommandLogic` | `toggleUserAttackLogStop` | `self, user, argc, args` | server-only | 1-7 |
| `AdminCommandLogic` | `toggleWorldServiceProfile` | `self, user, argc, args` | server-only | 1-102 |
| `AdminCommandLogic` | `tpChannel` | `self, user, argc, args` | server-only | 1-44 |
| `AdminCommandLogic` | `tpTest` | `self, user, argc, args` | server-only | 1-14 |
| `AdminCommandLogic` | `tpToAdmin` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `tpToUser` | `self, user, argc, args` | server-only | 1-74 |
| `AdminCommandLogic` | `tryCommand` | `self, msg, userId` | server-only | 1-25 |
| `AdminCommandLogic` | `trySave` | `self, user` | server-only | 1-4 |
| `AdminCommandLogic` | `uiposition` | `self, user` | server-only | 1-3 |
| `AdminCommandLogic` | `uipositionClient` | `self` | client | 1-17 |
| `AdminCommandLogic` | `updatePlayerQuestData` | `self, user, argc, args` | server-only | 1-21 |
| `AdminCommandLogic` | `updateQuestData` | `self, user, argc, args` | server-only | 1-9 |
| `AdminCommandLogic` | `warpMap` | `self, user, argc, args` | server-only | 1-11 |
| `AdminCommandLogic` | `whileTest1` | `self, user, argc, args` | server-only | 1-3 |
| `AdminCommandLogic` | `whileTest2` | `self, user, argc, args` | server-only | 1-4 |
| `AdminCommandLogic` | `worldInfo` | `self, user` | client | 1-5 |
| `AdvTamingMob` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `AdvTamingMob` | `tamepig_enter` | `self, player, udc` | server-only | 1-23 |
| `AdvTamingMob` | `tamepig_out` | `self, player, udc` | server-only | 1-6 |
| `AdvTamingMob` | `tamepig_out2` | `self, player, udc` | server-only | 1-6 |
| `Adventure0` | `begin5` | `self, player, udc` | server-only | 1-83 |
| `Adventure0` | `begin7` | `self, player, udc` | server-only | 1-27 |
| `Adventure0` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Adventure0` | `entertraining` | `self, player, udc` | server-only | 1-19 |
| `Adventure0` | `explorationPoint` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `go10000` | `self, player, udc` | server-only | 1-11 |
| `Adventure0` | `go1000000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1010000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1010100` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1010200` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1010300` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1010400` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go1020000` | `self, player, udc` | server-only | 1-6 |
| `Adventure0` | `go20000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go2000000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go30000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go40000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `go50000` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `goAdventure` | `self, player, udc` | server-only | 1-8 |
| `Adventure0` | `goArcher` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `goLith` | `self, player, udc` | server-only | 1-8 |
| `Adventure0` | `goMagician` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `goPirate` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `goRogue` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `goSwordman` | `self, player, udc` | server-only | 1-9 |
| `Adventure0` | `in_dollMaster00` | `self, player, udc` | server-only | 1-13 |
| `Adventure0` | `infoArcher` | `self, player, udc` | server-only | 1-10 |
| `Adventure0` | `infoAttack` | `self, player, udc` | server-only | 1-4 |
| `Adventure0` | `infoMagician` | `self, player, udc` | server-only | 1-10 |
| `Adventure0` | `infoMinimap` | `self, player, udc` | server-only | 1-4 |
| `Adventure0` | `infoPickup` | `self, player, udc` | server-only | 1-4 |
| `Adventure0` | `infoPirate` | `self, player, udc` | server-only | 1-10 |
| `Adventure0` | `infoReactor` | `self, player, udc` | server-only | 1-11 |
| `Adventure0` | `infoRogue` | `self, player, udc` | server-only | 1-10 |
| `Adventure0` | `infoSkill` | `self, player, udc` | server-only | 1-4 |
| `Adventure0` | `infoSwordman` | `self, player, udc` | server-only | 1-10 |
| `Adventure0` | `infoWorldmap` | `self, player, udc` | server-only | 1-4 |
| `Adventure0` | `rein` | `self, player, udc` | server-only | 1-5 |
| `Adventure0` | `tutoChatNPC` | `self, player, udc` | server-only | 1-18 |
| `Adventure1` | `bowman` | `self, player, udc` | server-only | 1-117 |
| `Adventure1` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Adventure1` | `change_archer` | `self, player, udc` | server-only | 1-27 |
| `Adventure1` | `change_magician` | `self, player, udc` | server-only | 1-28 |
| `Adventure1` | `change_rogue` | `self, player, udc` | server-only | 1-27 |
| `Adventure1` | `change_swordman` | `self, player, udc` | server-only | 1-31 |
| `Adventure1` | `enter_archer` | `self, player, udc` | server-only | 1-51 |
| `Adventure1` | `enter_magicion` | `self, player, udc` | server-only | 1-33 |
| `Adventure1` | `enter_pirate` | `self, player, udc` | server-only | 1-33 |
| `Adventure1` | `enter_thief` | `self, player, udc` | server-only | 1-33 |
| `Adventure1` | `enter_warrior` | `self, player, udc` | server-only | 1-33 |
| `Adventure1` | `fighter` | `self, player, udc` | server-only | 1-117 |
| `Adventure1` | `inside_archer` | `self, player, udc` | server-only | 1-19 |
| `Adventure1` | `inside_magician` | `self, player, udc` | server-only | 1-19 |
| `Adventure1` | `inside_pirate` | `self, player, udc` | server-only | 1-25 |
| `Adventure1` | `inside_rogue` | `self, player, udc` | server-only | 1-19 |
| `Adventure1` | `inside_swordman` | `self, player, udc` | server-only | 1-19 |
| `Adventure1` | `kairinT` | `self, player, udc` | server-only | 1-178 |
| `Adventure1` | `magician` | `self, player, udc` | server-only | 1-114 |
| `Adventure1` | `rogue` | `self, player, udc` | server-only | 1-138 |
| `Adventure2` | `_3jobExit` | `self, player, udc` | server-only | 1-17 |
| `Adventure2` | `bowman3` | `self, player, udc` | server-only | 1-79 |
| `Adventure2` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Adventure2` | `crack` | `self, player, udc` | client | 1-24 |
| `Adventure2` | `holySton` | `self, player, udc` | server-only | 1-79 |
| `Adventure2` | `holyStone` | `self, player, udc` | server-only | 1-128 |
| `Adventure2` | `pirate3` | `self, player, udc` | server-only | 1-79 |
| `Adventure2` | `portal_3th_jobQuestMap` | `self, player, udc` | server-only | 1-27 |
| `Adventure2` | `thief3` | `self, player, udc` | server-only | 1-96 |
| `Adventure2` | `warrior3` | `self, player, udc` | server-only | 1-98 |
| `Adventure2` | `wizard3` | `self, player, udc` | server-only | 1-80 |
| `Adventure3` | `archer4` | `self, player, udc` | server-only | 1-66 |
| `Adventure3` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Adventure3` | `magician4` | `self, player, udc` | server-only | 1-71 |
| `Adventure3` | `minar_job4` | `self, player, udc` | server-only | 1-6 |
| `Adventure3` | `pirate4` | `self, player, udc` | server-only | 1-64 |
| `Adventure3` | `thief4` | `self, player, udc` | server-only | 1-69 |
| `Adventure3` | `warrior4` | `self, player, udc` | server-only | 1-71 |
| `AfterImageManager` | `getAfterIamageAnim` | `self, weaponKey, masteryLevel, motionKey, charge` | client | 1-32 |
| `AfterImageManager` | `getAfterImageData` | `self, weaponKey, masteryLevel, motionKey, charge` | client | 1-31 |
| `AfterImageManager` | `getAfterImageLtRb` | `self, weaponKey, masteryLevel, motionKey, charge` | client | 1-27 |
| `AfterImageManager` | `getAfterImageNode` | `self, path` | client | 1-26 |
| `AfterImageManager` | `getAnim` | `self, path` | client | 1-30 |
| `AfterImageManager` | `loadData` | `self` | client | 1-73 |
| `AfterImageManager` | `parseAfterimage` | `self, data, weaponKey` | client | 1-32 |
| `AfterImageManager` | `parseHit` | `self, data, weaponKey` | client | 1-43 |
| `AfterImageManager` | `parseMotions` | `self, motions, weaponKey, masteryLevel, skillbook, skillID, charge` | client | 1-108 |
| `AnimationEngine` | `dequeue` | `self, index` | client | 1-7 |
| `AnimationEngine` | `enqueue` | `self, entity, func, delay` | client | 1-6 |
| `AnimationEngine` | `OnBeginPlay` | `self` | server-only | 1-28 |
| `AntiCheatLogic` | `appendCraftMaterialEntry` | `self, materials, itemID, quantity` | server-only | 1-10 |
| `AntiCheatLogic` | `appendItemOptionEntry` | `self, options, optionType, value` | server-only | 1-6 |
| `AntiCheatLogic` | `appendNumericItemOption` | `self, options, optionType, value` | server-only | 1-6 |
| `AntiCheatLogic` | `appendPotentialItemOptionChanges` | `self, changes, beforeItem, afterItem, itemID` | server-only | 1-19 |
| `AntiCheatLogic` | `appendPotentialItemOptions` | `self, options, item, itemID, includeEmptyPotentialOptions` | server-only | 1-9 |
| `AntiCheatLogic` | `appendUseScrollOptionChange` | `self, changes, beforeItem, afterItem, optionType, key` | server-only | 1-5 |
| `AntiCheatLogic` | `applyAutoBan` | `self, attacker, reasonText, banCode` | server-only | 1-12 |
| `AntiCheatLogic` | `applyAutoBanDelayed` | `self, attacker, reasonText, banCode` | server-only | 1-11 |
| `AntiCheatLogic` | `assertForHack` | `self, user, hackID, data, autoban` | server-only | 1-41 |
| `AntiCheatLogic` | `buildCraftMaterialsFromExchangeList` | `self, exchangeList` | server-only | 1-27 |
| `AntiCheatLogic` | `buildItemOptionList` | `self, equipInfo, itemID, baseUpgradeCount, includeEmptyPotentialOptions` | server-only | 1-41 |
| `AntiCheatLogic` | `buildItemOptionLogString` | `self, equipInfo, itemID, baseUpgradeCount, includeEmptyPotentialOptions` | server-only | 1-7 |
| `AntiCheatLogic` | `buildPotentialOptionList` | `self, equipInfo, itemID` | server-only | 1-9 |
| `AntiCheatLogic` | `buildPotentialOptionLogString` | `self, equipInfo, itemID` | server-only | 1-7 |
| `AntiCheatLogic` | `buildUseScrollChangeList` | `self, beforeItem, afterItem, itemID, baseUpgradeCount` | server-only | 1-34 |
| `AntiCheatLogic` | `checkTeleportKill` | `self, attacker, mob, skillID, skillLevel` | server-only | 1-49 |
| `AntiCheatLogic` | `enqueueAutoBanRequest` | `self, attacker, reasonText, banCode` | server-only | 1-29 |
| `AntiCheatLogic` | `getAllowedDeadlyAttackDistance` | `self, attacker, skillID, skillLevel` | server-only | 1-35 |
| `AntiCheatLogic` | `getCraftItemName` | `self, itemID` | server-only | 1-6 |
| `AntiCheatLogic` | `getCraftItemSN` | `self, equipInfo` | server-only | 1-17 |
| `AntiCheatLogic` | `getItemOptionReqLevel` | `self, item, itemID` | server-only | 1-17 |
| `AntiCheatLogic` | `getItemOptionValue` | `self, item, key` | server-only | 1-6 |
| `AntiCheatLogic` | `getPotentialItemOptionValue` | `self, item, itemID, poKey` | server-only | 1-25 |
| `AntiCheatLogic` | `getSpeedHackExceptionDuration` | `self, reason` | server-only | 1-8 |
| `AntiCheatLogic` | `getSpeedHackExceptionReasonBySkill` | `self, skillID` | server-only | 1-46 |
| `AntiCheatLogic` | `logHack` | `self, user, hackID, data, isBanned, hackCount` | server-only | 1-64 |
| `AntiCheatLogic` | `normalizeItemOptionEquipInfo` | `self, equipInfo` | server-only | 1-70 |
| `AntiCheatLogic` | `recordUserHistory` | `self, userID` | server-only | 1-15 |
| `AntiCheatLogic` | `registerDeadlyAttackViolation` | `self, attacker, mob, skillID, skillLevel, distance, allowedDistance` | server-only | 1-25 |
| `AntiCheatLogic` | `registerPickupDistanceViolation` | `self, attacker, dropPos, distance, allowedDistance, pickedByPet` | server-only | 1-24 |
| `AntiCheatLogic` | `registerTeleportKillViolation` | `self, attacker, mob, skillID, skillLevel, lastPos, currentPos, elapsed, distance, speed` | server-only | 1-34 |
| `AntiCheatLogic` | `sendAuctionEventLog` | `self, eventType, saleId, requestSN, extra, user` | server-only | 1-20 |
| `AntiCheatLogic` | `sendCraftItemLog` | `self, craftType, result, targetItemID, targetItemQuantity, beforeEquipInfo, resultEquipInfo, materials, user` | server-only | 1-42 |
| `AntiCheatLogic` | `sendCreateCharacterLog` | `self, isAdmin, name, level, job, mapID, userID, playerID` | server-only | 1-17 |
| `AntiCheatLogic` | `sendCreateItemLog` | `self, createType, itemID, quantity, starttime, source, sourceID, user, itemSN, remain, itemOption` | server-only | 1-3 |
| `AntiCheatLogic` | `sendCreateItemLogWithSaleId` | `self, createType, itemID, quantity, starttime, source, sourceID, user, itemSN, remain, itemOption, saleId` | server-only | 1-26 |
| `AntiCheatLogic` | `sendDeleteCharacterLog` | `self, isAdmin, name, level, job, mapID, userID, playerID` | server-only | 1-17 |
| `AntiCheatLogic` | `sendDiffrentDropMapPlayerMap` | `self, userID, playerMapID, dropMapID` | server-only | 1-13 |
| `AntiCheatLogic` | `sendDiffrentMapID` | `self, userID, playerMapID, mapInfoMapID` | server-only | 1-13 |
| `AntiCheatLogic` | `sendFieldBossKillLog` | `self, mob, killer, userCount` | server-only | 1-28 |
| `AntiCheatLogic` | `sendHackLog` | `self, userID, title, detail, cnt` | server-only | 1-3 |
| `AntiCheatLogic` | `sendKeyConfigSnapshot` | `self, user` | server-only | 1-9 |
| `AntiCheatLogic` | `sendMapMoveLog` | `self, moveType, user, beforeMap, afterMap` | server-only | 1-23 |
| `AntiCheatLogic` | `sendMobJumpHackLog` | `self, user, mob` | server-only | 1-21 |
| `AntiCheatLogic` | `sendMSWWorldLog` | `self, logTitle, details, user` | server-only | 1-63 |
| `AntiCheatLogic` | `sendPotentialUpgradeLog` | `self, potentialType, itemID, remain, targetItemID, targetItemSN, beforeItem, afterItem, user` | server-only | 1-26 |
| `AntiCheatLogic` | `sendQuestLog` | `self, questID, state, user` | server-only | 1-26 |
| `AntiCheatLogic` | `sendRemoveItemLog` | `self, removeType, itemID, quantity, starttime, user, itemSN, remain, itemOption` | server-only | 1-3 |
| `AntiCheatLogic` | `sendRemoveItemLogWithSaleId` | `self, removeType, itemID, quantity, starttime, user, itemSN, remain, itemOption, saleId` | server-only | 1-24 |
| `AntiCheatLogic` | `sendScreenShotLog` | `self, desc` | client | 1-3 |
| `AntiCheatLogic` | `sendSpeedHackExceptionBySkill` | `self, user, skillID` | server-only | 1-8 |
| `AntiCheatLogic` | `sendSpeedHackExceptionLog` | `self, user, duration, reason` | server-only | 1-10 |
| `AntiCheatLogic` | `sendTradeLog` | `self, SN, senderUserID, receiverUserID, moveType, itemID, quantity, itemSN, remain, equipInfo` | server-only | 1-3 |
| `AntiCheatLogic` | `sendTradeLogWithSaleId` | `self, SN, senderUserID, receiverUserID, moveType, itemID, quantity, itemSN, remain, equipInfo, saleId` | server-only | 1-32 |
| `AntiCheatLogic` | `sendUseMoveSkillLog` | `self, skillID, user` | server-only | 1-15 |
| `AntiCheatLogic` | `sendUserConnectFlowLog` | `self, type, user` | server-only | 1-8 |
| `AntiCheatLogic` | `sendUserReportHackLog` | `self, reporter, reported, reportDescription` | server-only | 1-29 |
| `AntiCheatLogic` | `sendUseScrollLog` | `self, scrollItemID, remain, result, targetItemID, targetItemSN, beforeItem, afterItem, baseUpgradeCount, user` | server-only | 1-4 |
| `AntiCheatLogic` | `sendUseScrollLogWithType` | `self, logType, scrollItemID, remain, result, targetItemID, targetItemSN, beforeItem, afterItem, baseUpgradeCount, user` | server-only | 1-25 |
| `AntiCheatLogic` | `shouldBlockDeadlyAttack` | `self, attacker, mob, skillID, skillLevel, damages` | server-only | 1-37 |
| `AntiMacroLogic` | `addTimeOutTimer` | `self, userID, timerID` | server-only | 1-3 |
| `AntiMacroLogic` | `applyPlayerDetails` | `self, userID, details` | server-only | 1-13 |
| `AntiMacroLogic` | `canStartBotDetectionLieDetector` | `self, user, userID, now` | server-only | 1-30 |
| `AntiMacroLogic` | `clearTimeOutTimer` | `self, userID` | server-only | 1-7 |
| `AntiMacroLogic` | `consumeLieDetectorReserveConsumeOnSuccess` | `self, userID` | server-only | 1-8 |
| `AntiMacroLogic` | `detectedMacro` | `self, userID` | server-only | 1-3 |
| `AntiMacroLogic` | `execute_Mobile` | `self, userID, type, createType` | server-only | 1-5 |
| `AntiMacroLogic` | `executeLieDetector` | `self, userID, type, createType` | server-only | 1-24 |
| `AntiMacroLogic` | `executeLieDetectorByStartBotDetectionEvent` | `self, userID, type` | server-only | 1-8 |
| `AntiMacroLogic` | `getJailedRemainMinute` | `self, count` | server-only | 1-11 |
| `AntiMacroLogic` | `hackLog` | `self, userID, title, details` | server-only | 1-4 |
| `AntiMacroLogic` | `HandleMacroReceivedTestQuestionEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestCloseByTimeoutEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestCloseEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestCountDownStartEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestDelayedShutdownEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestEndEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestReadyEvent` | `self, event` | client | 1-4 |
| `AntiMacroLogic` | `HandleMacroTestReceiveEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestSendEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `HandleMacroTestStartEvent` | `self, event` | client | 1-3 |
| `AntiMacroLogic` | `hasRecentBotDetectionActivity` | `self, user, now` | server-only | 1-14 |
| `AntiMacroLogic` | `isLieDetectorRunning` | `self, userID` | server-only | 1-13 |
| `AntiMacroLogic` | `isStartBotDetectionHuntingField` | `self, user` | server-only | 1-12 |
| `AntiMacroLogic` | `jailedUser` | `self, userID, onlyOnlinePlayer` | server-only | 1-46 |
| `AntiMacroLogic` | `log_LieDetect` | `self, userID, type, code` | server-only | 1-28 |
| `AntiMacroLogic` | `logValue` | `self, userID, title, details` | server-only | 1-5 |
| `AntiMacroLogic` | `logValue_requestLieDetect` | `self, userID, type, code, createType` | server-only | 1-21 |
| `AntiMacroLogic` | `macroCallback` | `self, userID, code, createType` | server-only | 1-14 |
| `AntiMacroLogic` | `OnBeginPlay` | `self` | server-only | 1-13 |
| `AntiMacroLogic` | `reduceReserveCountOnLieDetectorSuccess` | `self, userID` | server-only | 1-9 |
| `AntiMacroLogic` | `releaseJailedUser` | `self, userID` | server-only | 1-23 |
| `AntiMacroLogic` | `request_log_transparent` | `self, title, senderUserId` | server-only | 1-16 |
| `AntiMacroLogic` | `setActiveProbability` | `self, value` | server-only | 1-10 |
| `AntiMacroLogic` | `setLieDetectorReserveConsumeOnSuccess` | `self, userID, consume` | server-only | 1-13 |
| `AntiMacroLogic` | `tryLieDetectorReservaition` | `self, user, addCount` | server-only | 1-12 |
| `AntiRepeat` | `clearRepeat` | `self` | client | 1-13 |
| `AntiRepeat` | `OnBeginPlay` | `self` | client | 1-3 |
| `AntiRepeat` | `tryRepeat` | `self, type` | client | 1-25 |
| `AranLogic` | `canRecordFinalAttackCommand` | `self, now` | client | 1-11 |
| `AranLogic` | `canUseAranActionInput` | `self, user` | client | 1-43 |
| `AranLogic` | `canUseAranCommandSkill` | `self, attacker` | client | 1-3 |
| `AranLogic` | `canUseCombatStepAfterBasicAttack` | `self, player, currentTime` | client | 1-8 |
| `AranLogic` | `canUseCombatStepByGround` | `self, player` | client | 1-6 |
| `AranLogic` | `clearFinalCommandInput` | `self` | client | 1-6 |
| `AranLogic` | `getAranAttackTargetCountByLevel` | `self, level` | client | 1-13 |
| `AranLogic` | `getAranComboCommandSkillID` | `self, user, commandType` | client | 1-9 |
| `AranLogic` | `getAranCommandSkillInfo` | `self, user, swingType, isFullSwing, finalAttackType` | client | 1-52 |
| `AranLogic` | `getAranTutorialMapId` | `self, user` | client | 1-17 |
| `AranLogic` | `getBasicAttackEndTime` | `self` | client | 1-3 |
| `AranLogic` | `getBasicAttackMotion` | `self, attacker, skillID` | client | 1-9 |
| `AranLogic` | `getBasicAttackTotalActionDelay` | `self, attacker, skillID, defaultDelay` | client | 1-13 |
| `AranLogic` | `getDefaultAttackMobCount` | `self, attacker, defaultCount` | client | 1-9 |
| `AranLogic` | `getDirectionInputX` | `self, input` | client | 1-9 |
| `AranLogic` | `getDisplayLevel` | `self, user, realLevel` | client | 1-6 |
| `AranLogic` | `getLastBasicAttackTime` | `self` | client | 1-3 |
| `AranLogic` | `getRangeDelayForLocalPlayer` | `self, skillID` | client | 1-7 |
| `AranLogic` | `isAranComboCommandSkill` | `self, skillID` | client | 1-3 |
| `AranLogic` | `isAranCommandSkill` | `self, skillID` | client | 1-9 |
| `AranLogic` | `isAranPolearmWeapon` | `self, attacker` | client | 1-10 |
| `AranLogic` | `isAranTutorialCommandMode` | `self, attacker` | client | 1-10 |
| `AranLogic` | `isAranTutorialMissOnlyMap` | `self, user` | client | 1-11 |
| `AranLogic` | `isAranTutorialStatMap` | `self, user` | client | 1-5 |
| `AranLogic` | `isAranTutorialStatMapId` | `self, mapId` | client | 1-4 |
| `AranLogic` | `isBlockedIntroWindow` | `self, uiName` | client | 1-11 |
| `AranLogic` | `isDownProneBasicAttackInput` | `self, attacker` | client | 1-6 |
| `AranLogic` | `isIntroMap` | `self` | client | 1-8 |
| `AranLogic` | `isLocalAranPlayer` | `self, user` | client | 1-3 |
| `AranLogic` | `onAranCommandSkill` | `self, user, token, swingType, isFullSwing, finalAttackType` | client | 1-176 |
| `AranLogic` | `onCombatSteb` | `self, p, skillLevel, inputDirX` | client | 1-71 |
| `AranLogic` | `onDoubleClickSameDirectionKey` | `self, player, inputDirX` | client | 1-15 |
| `AranLogic` | `recordAranComboSkillCommandDirection` | `self, user, input` | client | 1-42 |
| `AranLogic` | `recordAranCommandDirection` | `self, user, input` | client | 1-25 |
| `AranLogic` | `recordBasicAttack` | `self, user, attackTime` | client | 1-14 |
| `AranLogic` | `recordFinalBlowDownCommand` | `self, user` | client | 1-10 |
| `AranLogic` | `recordFinalChargeForwardCommand` | `self, user, input` | client | 1-15 |
| `AranLogic` | `recordFinalTossUpCommand` | `self, user` | client | 1-10 |
| `AranLogic` | `reserveAranCommandSkillToken` | `self` | client | 1-17 |
| `AranLogic` | `resetAranComboSkillCommand` | `self` | client | 1-6 |
| `AranLogic` | `resetAranCommandSkillCheck` | `self` | client | 1-23 |
| `AranLogic` | `runReservedFinalBlow` | `self, user, token` | client | 1-15 |
| `AranLogic` | `scheduleReservedFinalBlow` | `self, user, token, delay` | client | 1-17 |
| `AranLogic` | `setAranComboSkillCommand` | `self, step, commandType, now` | client | 1-5 |
| `AranLogic` | `setBasicAttackTime` | `self, attackTime, triggerTime` | client | 1-7 |
| `AranLogic` | `shouldConsumeAranComboCommandSkill` | `self, skillID` | client | 1-8 |
| `AranLogic` | `tryConsumePendingFinalBlowAction` | `self, user` | client | 1-34 |
| `AranLogic` | `tryReserveAranCommandSkill` | `self, user, isFreshAttackInput` | client | 1-167 |
| `AranLogic` | `tryUseAranComboCommandSkill` | `self, user` | client | 1-105 |
| `AranPassManager` | `canGainAranPassRewards` | `self, user, rewards` | server-only | 1-91 |
| `AranPassManager` | `canUseAranPass` | `self, user` | server-only | 1-8 |
| `AranPassManager` | `claimAllAranPassRewardsServerOnly` | `self, user, userId` | server-only | 1-49 |
| `AranPassManager` | `claimAranPassRewardServerOnly` | `self, user, rewardIndex, userId` | server-only | 1-49 |
| `AranPassManager` | `createAranPassRewardItemInfo` | `self, itemID, flag, expTime` | server-only | 1-26 |
| `AranPassManager` | `gainAranPassRewards` | `self, user, rewards` | server-only | 1-25 |
| `AranPassManager` | `getAranPassClaimKey` | `self, level` | client | 1-3 |
| `AranPassManager` | `getAranPassReward` | `self, rewardIndex` | client | 1-3 |
| `AranPassManager` | `getAranPassRewardCount` | `self` | client | 1-3 |
| `AranPassManager` | `getAranPassRewardExpireTime` | `self` | client | 1-5 |
| `AranPassManager` | `getAranPassRewards` | `self` | client | 1-17 |
| `AranPassManager` | `getClaimedBitMaskServerOnly` | `self, user` | server-only | 1-13 |
| `AranPassManager` | `getPlayerLevelServerOnly` | `self, user` | server-only | 1-7 |
| `AranPassManager` | `isAranPassClaimed` | `self, user, level` | server-only | 1-8 |
| `AranPassManager` | `onAranPassClaimResultClient` | `self, success, message, level, claimedBitMask` | client | 1-11 |
| `AranPassManager` | `onAranPassStateClient` | `self, isAran, level, claimedBitMask` | client | 1-7 |
| `AranPassManager` | `requestAranPassStateServer` | `self, senderUserId` | server-only | 1-9 |
| `AranPassManager` | `requestClaimAllAranPassRewardsServer` | `self, senderUserId` | server-only | 1-9 |
| `AranPassManager` | `requestClaimAranPassRewardServer` | `self, rewardIndex, senderUserId` | server-only | 1-9 |
| `AranPassManager` | `syncAranPassStateServerOnly` | `self, user, userId` | server-only | 1-8 |
| `AreaBossManager` | `canSpawn` | `self, mapID` | server-only | 1-17 |
| `AreaBossManager` | `getAreaBossInfo` | `self, mapID` | server-only | 1-3 |
| `AreaBossManager` | `newInfo` | `self, mapID, mobTemplateID, pt, spawnedMessage, regenTime` | server-only | 1-20 |
| `AreaBossManager` | `parseAreaBoss` | `self` | server-only | 1-19 |
| `BalogPQ` | `balog_accept` | `self, p` | server-only | 1-38 |
| `BalogPQ` | `balogBattle_start` | `self` | server-only | 1-8 |
| `BalogPQ` | `cacheScriptFunc` | `self` | server-only | 1-10 |
| `BaseManager` | `getStandardPDD` | `self, job, level` | client | 1-27 |
| `BaseManager` | `loadBase` | `self` | client | 1-29 |
| `Bit32` | `band` | `self, a, b` | client | 1-15 |
| `Bit32` | `lshift` | `self, x, n` | client | 1-3 |
| `Bit32` | `rshift` | `self, x, n` | client | 1-3 |
| `Bit32` | `toBitFlag` | `self, value` | client | 1-3 |
| `BitmapFontManager` | `getGlyphRUID` | `self, font, code` | client | 1-4 |
| `BitmapFontManager` | `getGlyphSize` | `self, font, code` | client | 1-9 |
| `BitmapFontManager` | `isvalidKSX1001` | `self, cp` | client | 1-9 |
| `BitmapFontManager` | `loadBitmapFont` | `self` | client | 1-19 |
| `BitmapFontManager` | `loadGlyphRUID` | `self, collection` | client | 1-20 |
| `BitmapFontManager` | `loadSizeTable` | `self, collection` | client | 1-33 |
| `BitmapFontManager` | `preloadFonts` | `self` | client | 1-3 |
| `BitmapFontService` | `buildRichMetricsCacheKey` | `self, text, font, defaultColor, richText, maxLineW, alignment, convertEscapedNewline` | client | 1-23 |
| `BitmapFontService` | `calcTextMetrics` | `self, text, font, maxWidth` | client | 1-69 |
| `BitmapFontService` | `calcTotalWidth` | `self, text, font, convertEscapedNewline` | client | 1-44 |
| `BitmapFontService` | `clearRichMetricsCache` | `self` | client | 1-6 |
| `BitmapFontService` | `colorToHexRRGGBB` | `self, c` | client | 1-10 |
| `BitmapFontService` | `convertLegacyRichToMSW` | `self, text, defaultColor, convertEscapedNewline, playerEntity` | client | 1-185 |
| `BitmapFontService` | `getOffset` | `self, alignment, contentW, lineW` | client | 1-9 |
| `BitmapFontService` | `getRichMetricsCached` | `self, text, font, defaultColor, richText, maxLineW, lineGap, alignment, convertEscapedNewline, startPos` | client | 1-54 |
| `BitmapFontService` | `isQuestAlramDataContentEntity` | `self, parent` | client | 1-14 |
| `BitmapFontService` | `measureRich` | `self, tokens, font, startPos, maxLineW, lineGap, alignment` | client | 1-71 |
| `BitmapFontService` | `measureRichWithSelect` | `self, playerEntity, tokens, font, maxLineW, lineGap, alignment, startPos, defaultColor` | client | 1-735 |
| `BitmapFontService` | `normalizeRichSourceText` | `self, text, convertEscapedNewline` | client | 1-21 |
| `BitmapFontService` | `OnBeginPlay` | `self` | client | 1-3 |
| `BitmapFontService` | `renderBitmapText` | `self, parent, text, font, startPos, color, minimap, outline, outlineColor, richText, maxLineWidth, alignmentType, tokens` | client | 1-166 |
| `BitmapFontService` | `renderBitmapText_World` | `self, parent, text, font, startPos, color, maxWidth, sortingLayer, orderInLayer, alignmentType, applyBaseYOffset, legacyWorldLayout` | client | 1-206 |
| `BitmapFontService` | `renderRich` | `self, tokens, metrics, parent, text, font, startPos, color, minimap, outline, outlineColor, LINE_GAP, alignment, udc, isUtilDlg` | client | 1-353 |
| `BitmapFontService` | `renderRichByCache` | `self, metrics, parent, font, startPos, color, minimap, outline, outlineColor, LINE_GAP, alignment, udc, isUtilDlg` | client | 1-391 |
| `BitmapFontService` | `resolveLegacyRichDynamicText` | `self, tagType, payload, playerEntity` | client | 1-40 |
| `BitmapFontService` | `tokenizeRich` | `self, text, defaultColor, richText, convertEscapedNewline` | client | 1-332 |
| `BitmapFontService` | `tripToBytes` | `self, str, maxByte` | client | 1-42 |
| `BitmapFontService` | `wrapTextByWidth` | `self, text, font, maxWidth, convertEscapedNewline` | client | 1-49 |
| `BlowWeatherLogic` | `addParticle` | `self, map, spawnPos` | client | 1-3 |
| `BlowWeatherLogic` | `test` | `self, map, type, direction, speed` | client | 1-8 |
| `CTS` | `checkFlag` | `self, flag, value` | client | 1-6 |
| `CTS` | `decodeCTSFlag` | `self, flag` | client | 1-13 |
| `CTS` | `flagToIndex` | `self, flag, page` | client | 1-24 |
| `CTS` | `getFlag` | `self, index` | client | 1-6 |
| `CTS` | `getPage` | `self, index` | client | 1-6 |
| `CTS` | `isCanDispelDisease` | `self, flagIndex` | client | 1-13 |
| `CTS` | `isDisease` | `self, flagIndex` | client | 1-6 |
| `CTS` | `isIndieTemporaryStat` | `self, index` | client | 1-11 |
| `CalcDamageLogic` | `applyAdminFixedDamage` | `self, attacker, damages, criticals` | client | 1-14 |
| `CalcDamageLogic` | `applyAdminFixedSingleDamage` | `self, attacker, damage` | client | 1-9 |
| `CalcDamageLogic` | `applyAranMultiTargetDamageRate` | `self, attacker, damages, targetCount` | client | 1-20 |
| `CalcDamageLogic` | `applyAttackDamageRateBoost` | `self, damages, skillID, skillLevel` | client | 1-17 |
| `CalcDamageLogic` | `applyHiddenAttackDamageBoost` | `self, attacker, damages` | client | 1-9 |
| `CalcDamageLogic` | `applyPDRateFinalDamage` | `self, attacker, mob, damages` | client | 1-33 |
| `CalcDamageLogic` | `calcAttackDamage` | `self, attacker, skillID, attackMotion, mastery, isMagic, targetCount, bulletSlot, hitIndex, masteryPad` | client | 1-305 |
| `CalcDamageLogic` | `calcDamage` | `self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack` | client | 1-14 |
| `CalcDamageLogic` | `calcDamage_MDamageMvM` | `self, user, attackMob, targetMob, attackInfo` | client | 1-28 |
| `CalcDamageLogic` | `calcDamage_MDamageMvP` | `self, player, mob, mobAttack, rand` | client | 1-62 |
| `CalcDamageLogic` | `calcDamage_MDamageMvS` | `self, mobEntity, attackInfo, nSLV, rand` | client | 1-28 |
| `CalcDamageLogic` | `calcDamage_MDamagePvM` | `self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, targetCount, mobOrder, chargePer` | client | 1-206 |
| `CalcDamageLogic` | `calcDamage_MDamageSvM` | `self, owner, mobEntity, skillID, SLV` | client | 1-56 |
| `CalcDamageLogic` | `calcDamage_MesoExplosion` | `self, player, mob, skillID, skillLevel, mesos` | client | 1-27 |
| `CalcDamageLogic` | `calcDamage_PDamageMvM` | `self, user, attackMob, targetMob, attackInfo` | client | 1-31 |
| `CalcDamageLogic` | `calcDamage_PDamageMvP` | `self, player, mob, mobAttack, rand` | client | 1-92 |
| `CalcDamageLogic` | `calcDamage_PDamageMvS` | `self, mobEntity, attackInfo, nSLV, rand` | client | 1-34 |
| `CalcDamageLogic` | `calcDamage_PDamagePvM` | `self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, finalAttackSkillID, bulletSlot, mobOrder, chargePer, finishAttack, targetCount, damageRandOverride, statRandOverride` | client | 1-404 |
| `CalcDamageLogic` | `calcDamage_PDamageSvM` | `self, owner, mobEntity, skillID, SLV` | client | 1-56 |
| `CalcDamageLogic` | `calcFixedDamageRateMvP` | `self, player, fixDamR` | client | 1-13 |
| `CalcDamageLogic` | `checkMDamageMiss` | `self, player, mob, rand` | client | 1-53 |
| `CalcDamageLogic` | `checkPDamageMiss` | `self, player, mob, rand` | client | 1-58 |
| `CalcDamageLogic` | `getAdminFixedDamage` | `self, attacker` | client | 1-13 |
| `CalcDamageLogic` | `getAmplification` | `self, attacker, skillID` | client | 1-46 |
| `CalcDamageLogic` | `getAppliedDamageRateLevelData` | `self, attacker, skillID, skillLevel, baseLevelData` | client | 1-21 |
| `CalcDamageLogic` | `getAranMultiTargetDamageRate` | `self, playerLevel, targetCount` | client | 1-9 |
| `CalcDamageLogic` | `getAssassinateElapsedSeconds` | `self, attacker, skillID, levelData` | client | 1-21 |
| `CalcDamageLogic` | `getCounterDamage` | `self, mob, skillID` | client | 1-22 |
| `CalcDamageLogic` | `getFinalTossDamageBonus` | `self, mob, damage, appliedSkillDamageRate` | client | 1-12 |
| `CalcDamageLogic` | `getMesoGuardReduce` | `self, player, damage` | client | 1-36 |
| `CalcDamageLogic` | `getPDRateAdjustedDamageMultiplier` | `self, attacker, mob` | client | 1-26 |
| `CalcDamageLogic` | `getSkillAttackType` | `self, skillID` | client | 1-20 |
| `CalcDamageLogic` | `getSparkDamageRate` | `self, attacker` | client | 1-6 |
| `CalcDamageLogic` | `isShootAction` | `self, motion` | client | 1-7 |
| `CalcDamageLogic_Element` | `getDamageAdjustedByAssistChargedElemAttr` | `self, player, mob, damage` | client | 1-45 |
| `CalcDamageLogic_Element` | `getDamageAdjustedByChargedElemAttr` | `self, player, mob, damage` | client | 1-20 |
| `CalcDamageLogic_Element` | `getDamageAdjustedByElemAttr` | `self, player, mob, damage, skillID, skillLevel` | client | 1-52 |
| `CalcDamageLogic_Element` | `getDamageAdjustedByElemAttr_` | `self, damage, attr, adjust, boost, elemeReset` | client | 1-17 |
| `CalcDamageLogic_Element` | `getDamageAdjustedByPhysicalElemAttr` | `self, player, mob, damage, skillID, checkWeaponCharge` | client | 1-14 |
| `CalcDamageLogic_Element` | `getMainChargeSkillID` | `self, player` | client | 1-14 |
| `CalcDamageLogic_Element` | `hasElementalWeaponCharge` | `self, player` | client | 1-13 |
| `CalcDamageLogic_Element` | `hasSkillElement` | `self, skillID` | client | 1-8 |
| `CashShopChargeLogic` | `OnBeginPlay` | `self` | server-only | 1-3 |
| `CashShopChargeLogic` | `processWCPurchase` | `self, purchaseInfo` | server-only | 1-161 |
| `ChatLogic` | `activateChatField` | `self` | client | 1-31 |
| `ChatLogic` | `addChatLog` | `self, messageType, message` | client | 1-3 |
| `ChatLogic` | `addChatLog_` | `self, messageType, message, from` | client | 1-120 |
| `ChatLogic` | `addWhisperHistory` | `self, target` | client | 1-18 |
| `ChatLogic` | `applyItemSpeakerTooltip` | `self, logEntity, meta` | client | 1-14 |
| `ChatLogic` | `applyMegaphoneIconX` | `self, logEntity, iconX` | client | 1-15 |
| `ChatLogic` | `bindItemSpeakerLogTouch` | `self, logEntity` | client | 1-21 |
| `ChatLogic` | `bindMegaphoneIconTouchEvent` | `self, iconEntity, logEntity` | client | 1-16 |
| `ChatLogic` | `buildMSWCharWidthCache` | `self, fontSize` | client | 1-54 |
| `ChatLogic` | `changeChatTarget` | `self, target` | client | 1-18 |
| `ChatLogic` | `clearChatLog` | `self` | client | 1-4 |
| `ChatLogic` | `clearItemSpeakerTooltip` | `self, logEntity` | client | 1-11 |
| `ChatLogic` | `clearLogEntry` | `self, logEntity` | client | 1-16 |
| `ChatLogic` | `closeMegaphoneUI` | `self` | client | 1-13 |
| `ChatLogic` | `decodeItemSpeakerMeta` | `self, marker` | client | 1-12 |
| `ChatLogic` | `drawText` | `self, messageType, message` | client | 1-50 |
| `ChatLogic` | `ensureItemMegaphoneSlot` | `self` | client | 1-52 |
| `ChatLogic` | `ensureItemSpeakerInlineNameEntity` | `self, logEntity` | client | 1-27 |
| `ChatLogic` | `ensureItemSpeakerTooltipProxy` | `self` | client | 1-23 |
| `ChatLogic` | `ensureMegaphoneIcon` | `self, logEntity` | client | 1-28 |
| `ChatLogic` | `ensureMegaphoneStateTables` | `self` | client | 1-8 |
| `ChatLogic` | `ensureMegaphoneUIBindings` | `self` | client | 1-52 |
| `ChatLogic` | `ensureMSWWidthProbeEntity` | `self` | client | 1-31 |
| `ChatLogic` | `extractMegaphoneSenderName` | `self, renderMsg, markerSenderName` | client | 1-15 |
| `ChatLogic` | `getActiveMegaphoneUIEntity` | `self` | client | 1-4 |
| `ChatLogic` | `getChatLogMSWFontSize` | `self` | client | 1-3 |
| `ChatLogic` | `getChatLogTextWidth` | `self` | client | 1-3 |
| `ChatLogic` | `getChatLogWrapTextWidth` | `self, text` | client | 1-6 |
| `ChatLogic` | `getMegaphoneInputText` | `self` | client | 1-21 |
| `ChatLogic` | `getMegaphoneSenderName` | `self, logEntity` | client | 1-4 |
| `ChatLogic` | `getMegaphoneUIEntity` | `self, itemId` | client | 1-6 |
| `ChatLogic` | `getMSWPreferredWidthCached` | `self, text, fontSize` | client | 1-53 |
| `ChatLogic` | `getRenderedMSWTextWidth` | `self, textEntity, text` | client | 1-16 |
| `ChatLogic` | `getTextWidth` | `self, text, font` | client | 1-16 |
| `ChatLogic` | `HandleTextInputSubmitEvent` | `self, event` | client | 1-14 |
| `ChatLogic` | `hideItemSpeakerInlineName` | `self, logEntity` | client | 1-13 |
| `ChatLogic` | `hideItemSpeakerTooltipPopup` | `self` | client | 1-11 |
| `ChatLogic` | `isHangulOrHanjaCodePoint` | `self, cp` | client | 1-13 |
| `ChatLogic` | `isLogRenderTokenCurrent` | `self, logEntity, token` | client | 1-9 |
| `ChatLogic` | `isMegaphoneRenderMessage` | `self, messageType, message` | client | 1-9 |
| `ChatLogic` | `isMobileChatUIActive` | `self` | client | 1-12 |
| `ChatLogic` | `issueLogRenderToken` | `self, logEntity` | client | 1-15 |
| `ChatLogic` | `OnBeginPlay` | `self` | client | 1-54 |
| `ChatLogic` | `onItemMegaphoneDropItem` | `self, itemId, invType, invSlot, ieqp` | client | 1-29 |
| `ChatLogic` | `onItemSpeakerLogTouchUp` | `self, logEntity` | client | 1-12 |
| `ChatLogic` | `onMegaphoneIconTouchUp` | `self, logEntity` | client | 1-17 |
| `ChatLogic` | `openMegaphoneUI` | `self` | client | 1-4 |
| `ChatLogic` | `openMegaphoneUIByItem` | `self, itemId` | client | 1-43 |
| `ChatLogic` | `parseItemSpeakerMetaMarker` | `self, message` | client | 1-8 |
| `ChatLogic` | `parseMegaphoneRenderMessage` | `self, message` | client | 1-18 |
| `ChatLogic` | `prepareItemSpeakerTooltip` | `self, meta` | client | 1-48 |
| `ChatLogic` | `renderItemSpeakerInlineName` | `self, logEntity, renderMsg, itemMeta` | client | 1-78 |
| `ChatLogic` | `renderLogEntry` | `self, logEntity, messageType, message` | client | 1-96 |
| `ChatLogic` | `resetItemMegaphoneSelectionUI` | `self` | client | 1-41 |
| `ChatLogic` | `sendMegaphoneFromUI` | `self` | client | 1-40 |
| `ChatLogic` | `setChatTargetText` | `self, target` | client | 1-10 |
| `ChatLogic` | `setMegaphoneIconVisible` | `self, logEntity, channelOrNil` | client | 1-41 |
| `ChatLogic` | `setMegaphoneInputText` | `self, value` | client | 1-30 |
| `ChatLogic` | `setMegaphoneSenderName` | `self, logEntity, senderName` | client | 1-4 |
| `ChatLogic` | `setWhisperTarget` | `self, target` | client | 1-10 |
| `ChatLogic` | `showItemSpeakerTooltipPopup` | `self, logEntity, meta` | client | 1-20 |
| `ChatLogic` | `showMobileItemSpeakerTooltipPopup` | `self, logEntity, meta, touchPoint` | client | 1-29 |
| `ChatLogic` | `showWhisperUI` | `self` | client | 1-31 |
| `ChatLogic` | `showWhisperUIWithDefault` | `self, defaultTarget` | client | 1-35 |
| `ChatLogic` | `startItemSpeakerTooltipDistanceWatcher` | `self, logEntity` | client | 1-24 |
| `ChatLogic` | `toggleMobileChatBoard` | `self, ignoreFocusedInput` | client | 1-15 |
| `ChatLogic` | `tryOpenMobileChatBoardWithTarget` | `self, target` | client | 1-14 |
| `ChatLogic` | `updateMegaphoneIconLayout` | `self, logEntity, isMini` | client | 1-19 |
| `ChatLogic` | `updateMobileChatLatest` | `self, messageType, message, channelNumber` | client | 1-7 |
| `ChatLogic` | `wrapChatLogMSWTextByWidth` | `self, text, wrapWidth` | client | 1-37 |
| `ChatLogic` | `wrapChatLogTextByWidth` | `self, text, wrapWidth` | client | 1-4 |
| `CheckNameUtils` | `contains_profanity` | `self, name` | client | 1-9 |
| `CheckNameUtils` | `hangulEulReulJosa` | `self, input` | client | 1-24 |
| `CheckNameUtils` | `hangulIGaJosa` | `self, input` | client | 1-24 |
| `CheckNameUtils` | `is_valid_name` | `self, name, checkBarcode` | client | 1-24 |
| `CheckNameUtils` | `len` | `self, str` | client | 1-60 |
| `CheckNameUtils` | `OnBeginPlay` | `self` | client | 1-23 |
| `ClientCommandLogic` | `checkRemoteFindBlockedByBlackList` | `self, foundUserId, requesterName, callback` | client | 1-36 |
| `ClientCommandLogic` | `commandChatAll` | `self, user, argc, args` | client | 1-3 |
| `ClientCommandLogic` | `commandFriend` | `self, user, argc, args` | client | 1-3 |
| `ClientCommandLogic` | `commandGuild` | `self, user, argc, args` | client | 1-3 |
| `ClientCommandLogic` | `commandParty` | `self, user, argc, args` | client | 1-3 |
| `ClientCommandLogic` | `commandPartyInfo` | `self, user, argc, args` | client | 1-53 |
| `ClientCommandLogic` | `commandWhisper` | `self, user, argc, args` | client | 1-16 |
| `ClientCommandLogic` | `createParty` | `self, user, argc, args` | client | 1-12 |
| `ClientCommandLogic` | `find` | `self, user, argc, args` | client | 1-8 |
| `ClientCommandLogic` | `findPlayer` | `self, targetName, senderUserId` | server-only | 1-80 |
| `ClientCommandLogic` | `help` | `self, user, argc, args` | client | 1-27 |
| `ClientCommandLogic` | `inviteGuild` | `self, user, argc, args` | client | 1-29 |
| `ClientCommandLogic` | `inviteParty` | `self, user, argc, args` | client | 1-11 |
| `ClientCommandLogic` | `inviteTrade` | `self, user, argc, args` | client | 1-14 |
| `ClientCommandLogic` | `isFindBlockedByAccountData` | `self, accountData, requesterName` | client | 1-15 |
| `ClientCommandLogic` | `isFindBlockedByOnlineTarget` | `self, requester, target` | client | 1-10 |
| `ClientCommandLogic` | `isNameInBlackListTable` | `self, blackList, targetName` | client | 1-34 |
| `ClientCommandLogic` | `kickPartyMember` | `self, user, argc, args` | client | 1-33 |
| `ClientCommandLogic` | `leaveParty` | `self, user, argc, args` | client | 1-17 |
| `ClientCommandLogic` | `OnBeginPlay` | `self` | client | 1-19 |
| `ClientCommandLogic` | `testFriendList` | `self, user, argc, args` | client | 1-7 |
| `ClientCommandLogic` | `trade` | `self, user, argc, args` | client | 1-22 |
| `ClientCommandLogic` | `tryCommand` | `self, msg` | client | 1-21 |
| `ColliderUtils` | `d` | `self, map, boxId, b` | client | 1-30 |
| `ColliderUtils` | `drawBox` | `self, map, position, size` | client | 1-24 |
| `ColliderUtils` | `drawBox2` | `self, map, position, size` | client | 1-19 |
| `ColliderUtils` | `drawBoxToClient` | `self, map, pos, lt, rb, left, boxId` | client | 1-4 |
| `ContinentManager` | `findContiMove` | `self, fieldID` | server-only | 1-11 |
| `ContinentManager` | `getInfo` | `self, fieldID, flag` | server-only | 1-9 |
| `ContinentManager` | `getUserCount` | `self, startShipMoveFieldID` | server-only | 1-12 |
| `ContinentManager` | `loadContinent` | `self` | server-only | 1-159 |
| `ContinentManager` | `OnEndPlay` | `self` | server-only | 1-3 |
| `ContinentManager` | `onUpdate` | `self` | server-only | 1-9 |
| `CruseFilter` | `filterChar` | `self, src, filterChars, ignoreNewLine` | client | 1-19 |
| `CruseFilter` | `isCharEqual` | `self, chr1, chr2` | client | 1-3 |
| `CruseFilter` | `searchSubstring` | `self, text, pattern` | client | 1-6 |
| `CruseFilter` | `strchrIgnoreCase` | `self, str, chr` | client | 1-9 |
| `DailyGiftManager` | `canGainDailyGiftReward` | `self, user, itemID, quantity, flag` | server-only | 1-11 |
| `DailyGiftManager` | `claimDailyGiftServerOnly` | `self, user, userId` | server-only | 1-59 |
| `DailyGiftManager` | `getDailyGift` | `self, day` | client | 1-3 |
| `DailyGiftManager` | `getDailyGiftFlag` | `self, day` | client | 1-7 |
| `DailyGiftManager` | `getDailyGiftItemID` | `self, day` | client | 1-7 |
| `DailyGiftManager` | `getDailyGiftQuantity` | `self, day` | client | 1-7 |
| `DailyGiftManager` | `getDailyGiftTable` | `self` | client | 1-3 |
| `DailyGiftManager` | `loadDailyGift` | `self` | client | 1-34 |
| `DailyGiftManager` | `onDailyGiftClaimResultClient` | `self, success, message, claimedDay, mobCount, lastDate` | client | 1-20 |
| `DailyGiftManager` | `requestClaimDailyGiftServer` | `self, senderUserId` | server-only | 1-7 |
| `DailyGiftManager` | `syncDailyGiftQuestExClient` | `self, mobCount, claimedDay, date, lastDate` | client | 1-15 |
| `DamageDecRate` | `adjustDamageDecRate` | `self, skillID, skillLevel, damages, order, isFinalSlashBlast, decStep` | client | 1-30 |
| `DamageDecRate` | `getVerticalAdjustOfAttackRange` | `self, skillID` | client | 1-23 |
| `DamageDecRate` | `getVerticalAdjustOfAttackRange_` | `self, a1` | client | 1-58 |
| `DamageDecRate` | `OnBeginPlay` | `self` | client | 1-16 |
| `DataLoadManager` | `beginStartupLogoGate` | `self` | client | 1-28 |
| `DataLoadManager` | `cancelStartupLogoGateAndShowLoading` | `self` | client | 1-14 |
| `DataLoadManager` | `compeletedLoad` | `self` | client | 1-35 |
| `DataLoadManager` | `finishClientLoadingToLogin` | `self` | client | 1-4 |
| `DataLoadManager` | `loadClient` | `self` | client | 1-89 |
| `DataLoadManager` | `OnBeginPlay` | `self` | client | 1-88 |
| `DataLoadManager` | `OnSyncProperty` | `self, name, value` | client | 1-11 |
| `DataLoadManager` | `playStartupLogo` | `self` | client | 1-13 |
| `DataLoadManager` | `setStartupLoadingVisible` | `self, visible` | client | 1-8 |
| `DataLoadManager` | `tryStartClientLoad` | `self` | client | 1-7 |
| `DataLoadManager` | `waitLoginAndFinishClientLoading` | `self, retryCount` | client | 1-13 |
| `DataSetUtils` | `getData` | `self, path, keyTitle, key, valueTitle` | client | 1-8 |
| `DataSetUtils` | `shuffleTable` | `self, t` | client | 1-7 |
| `DataSetUtils` | `spairs` | `self, tbl` | client | 1-13 |
| `DataSetUtils` | `split` | `self, str, sep` | client | 1-16 |
| `DayUtils` | `getDayOfWeekNumber` | `self, dow` | client | 1-3 |
| `DayUtils` | `OnBeginPlay` | `self` | client | 1-10 |
| `DedicatedMonsterLogic` | `buildLivePositions` | `self, mapLife, playerId` | server-only | 1-13 |
| `DedicatedMonsterLogic` | `canSpawnMobForPlayer` | `self, lp, playerId, curTime, reset, pt` | server-only | 1-11 |
| `DedicatedMonsterLogic` | `canTargetPlayer` | `self, mob, player` | client | 1-24 |
| `DedicatedMonsterLogic` | `clearAll` | `self, mapLife` | server-only | 1-28 |
| `DedicatedMonsterLogic` | `clearMobTracking` | `self, mapLife, mob` | server-only | 1-18 |
| `DedicatedMonsterLogic` | `clearPoolStateForInactivePools` | `self, mapLife, runtime, currentPlayers, currentPools` | server-only | 1-24 |
| `DedicatedMonsterLogic` | `createMobByLifePoolForPlayer` | `self, mapLife, lp, playerId` | server-only | 1-23 |
| `DedicatedMonsterLogic` | `ensurePlayerLiveMob` | `self, mapLife, playerId` | client | 1-8 |
| `DedicatedMonsterLogic` | `ensurePlayerOrder` | `self, runtime, playerId` | server-only | 1-10 |
| `DedicatedMonsterLogic` | `ensurePoolState` | `self, lp, playerId` | client | 1-8 |
| `DedicatedMonsterLogic` | `ensureRuntimeTables` | `self, mapLife` | server-only | 1-18 |
| `DedicatedMonsterLogic` | `getAuthorizedPools` | `self, runtime, currentPools, currentPlayers, poolMembers` | server-only | 1-49 |
| `DedicatedMonsterLogic` | `getCurrentPoolKey` | `self, player` | client | 1-22 |
| `DedicatedMonsterLogic` | `getCurrentPoolUsageCount` | `self, map` | client | 1-36 |
| `DedicatedMonsterLogic` | `getOwnerPlayerId` | `self, mapLife, mob` | client | 1-10 |
| `DedicatedMonsterLogic` | `getPartyLeaderPlayerId` | `self, user` | server-only | 1-20 |
| `DedicatedMonsterLogic` | `getPlayerCap` | `self, mapLife` | client | 1-12 |
| `DedicatedMonsterLogic` | `getVisualAlpha` | `self, mob, viewer` | client | 1-19 |
| `DedicatedMonsterLogic` | `initMobByIDForPlayer` | `self, mapLife, mobID, position, summonType, dwData, mobType, faceLeft, playerId` | server-only | 1-29 |
| `DedicatedMonsterLogic` | `isDedicatedMob` | `self, mapLife, mob` | client | 1-6 |
| `DedicatedMonsterLogic` | `isEnabledMap` | `self, map` | client | 1-30 |
| `DedicatedMonsterLogic` | `isOwnedMob` | `self, player, mob` | client | 1-21 |
| `DedicatedMonsterLogic` | `isPoolKeyOwnedByPlayer` | `self, player, ownerKey` | client | 1-19 |
| `DedicatedMonsterLogic` | `isSameOwnerMob` | `self, sourceMob, targetMob` | client | 1-13 |
| `DedicatedMonsterLogic` | `makePartyPoolKey` | `self, partyId` | client | 1-3 |
| `DedicatedMonsterLogic` | `makePlayerPoolKey` | `self, playerId` | client | 1-3 |
| `DedicatedMonsterLogic` | `migrateOrphanedPools` | `self, mapLife, runtime, poolKeyChanges, currentPools, previousPools` | server-only | 1-63 |
| `DedicatedMonsterLogic` | `mobPtInBox` | `self, lp, pt` | server-only | 1-14 |
| `DedicatedMonsterLogic` | `onMobRemoved` | `self, lp, mob, force` | server-only | 1-17 |
| `DedicatedMonsterLogic` | `registerDedicatedMob` | `self, mapLife, mob, playerId` | server-only | 1-10 |
| `DedicatedMonsterLogic` | `resetDedicatedPool` | `self, mapLife, runtime, poolKey` | server-only | 1-25 |
| `DedicatedMonsterLogic` | `resolvePoolKeyForUser` | `self, mapLife, user, partyCounts` | server-only | 1-18 |
| `DedicatedMonsterLogic` | `setPlayerPoolKey` | `self, user, poolKey` | server-only | 1-12 |
| `DedicatedMonsterLogic` | `transferPoolOwnership` | `self, mapLife, runtime, oldKey, newKey, carryAuthorization` | server-only | 1-67 |
| `DedicatedMonsterLogic` | `tryCreateMob` | `self, mapLife, curTime, reset` | server-only | 1-161 |
| `Delivery` | `cacheScriptFunc` | `self` | server-only | 1-12 |
| `Delivery` | `npc_9010009` | `self, player, udc` | server-only | 1-7 |
| `DeliveryLogic` | `applySendDraftSnapshotToClient` | `self, userId, slotSnapshot, meso` | server-only | 1-11 |
| `DeliveryLogic` | `applySendSlotClient` | `self, slotId, stackData` | client | 1-7 |
| `DeliveryLogic` | `beginActionLock` | `self, userId` | server-only | 1-10 |
| `DeliveryLogic` | `blockDeliveryByFieldLimit` | `self, user` | server-only | 1-8 |
| `DeliveryLogic` | `blockDeliveryByFieldLimitClient` | `self` | client | 1-16 |
| `DeliveryLogic` | `buildDeliveryRequestItem` | `self, src` | server-only | 1-28 |
| `DeliveryLogic` | `buildDeliveryRequestSignature` | `self, toName, memo, meso, nodeItems` | server-only | 1-21 |
| `DeliveryLogic` | `calcDeliveryBaseCostServer` | `self` | server-only | 1-3 |
| `DeliveryLogic` | `calcDeliveryFeeClient` | `self, sendMeso` | client | 1-8 |
| `DeliveryLogic` | `calcDeliveryFeeServer` | `self, sendMeso` | server-only | 1-8 |
| `DeliveryLogic` | `canCancelSentMailboxClient` | `self, node` | client | 1-23 |
| `DeliveryLogic` | `canCancelSentMailboxNode` | `self, node` | server-only | 1-23 |
| `DeliveryLogic` | `cancelSendDraft` | `self, senderUserId` | server-only | 1-7 |
| `DeliveryLogic` | `cancelSendDraftByUser` | `self, user` | server-only | 1-63 |
| `DeliveryLogic` | `canSendItem` | `self, itemStack` | server-only | 1-3 |
| `DeliveryLogic` | `clearLoginMailboxNoticeByUser` | `self, user` | server-only | 1-7 |
| `DeliveryLogic` | `clearPendingCancel` | `self, userId, deliveryId` | server-only | 1-10 |
| `DeliveryLogic` | `clearPendingReceive` | `self, userId, deliveryId` | server-only | 1-10 |
| `DeliveryLogic` | `clearPendingSend` | `self, userId` | server-only | 1-3 |
| `DeliveryLogic` | `clearSendDraftState` | `self, userId, sendSlots` | server-only | 1-10 |
| `DeliveryLogic` | `clearSendRequestKey` | `self, userId` | server-only | 1-4 |
| `DeliveryLogic` | `clearSendSlotClient` | `self, slotId` | client | 1-7 |
| `DeliveryLogic` | `clearUserRuntimeStateByUserId` | `self, userId, preservePendingSend` | server-only | 1-20 |
| `DeliveryLogic` | `cloneDeliveryEquipInfo` | `self, equipInfo` | server-only | 1-21 |
| `DeliveryLogic` | `cloneDeliveryValue` | `self, value` | server-only | 1-10 |
| `DeliveryLogic` | `collectDeletableMailboxDeleteIds` | `self, mailbox, deleteIds` | server-only | 1-19 |
| `DeliveryLogic` | `completeDeliverySendSuccess` | `self, user, userId, toName, requestKey, nodeItems, sendMeso, responseMsg` | server-only | 1-47 |
| `DeliveryLogic` | `copyMailboxForClient` | `self, mailbox` | server-only | 1-53 |
| `DeliveryLogic` | `copyMailboxNode` | `self, src` | server-only | 1-7 |
| `DeliveryLogic` | `copySendSlotSnapshot` | `self, sendSlots` | server-only | 1-13 |
| `DeliveryLogic` | `endActionLock` | `self, userId` | server-only | 1-6 |
| `DeliveryLogic` | `enqueueDeliveryCancelComplete` | `self, userId, playerName, deliveryId` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliveryCancelPendingReset` | `self, userId, playerName, deliveryId` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliveryCancelPrepare` | `self, userId, playerName, deliveryId` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliveryReceiveComplete` | `self, userId, playerName, deliveryId` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliveryReceivePendingReset` | `self, userId, playerName, deliveryId` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliverySendComplete` | `self, userId, playerName, requestKey, callback` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueDeliverySendPrepare` | `self, userId, playerName, req, callback` | server-only | 1-8 |
| `DeliveryLogic` | `enqueueDeliverySendRollbackFailure` | `self, userId, playerName, requestKey, reason, pendingEntry` | server-only | 1-21 |
| `DeliveryLogic` | `enqueueDeliverySendRollbackSuccess` | `self, userId, playerName, requestKey, callback` | server-only | 1-9 |
| `DeliveryLogic` | `enqueueSystemDelivery` | `self, userId, playerName, memo, expireDays, requestKey, callback` | server-only | 1-22 |
| `DeliveryLogic` | `enqueueSystemItemDelivery` | `self, userId, playerName, memo, expireDays, requestKey, items, callback` | server-only | 1-23 |
| `DeliveryLogic` | `findUserByName` | `self, playerName` | server-only | 1-12 |
| `DeliveryLogic` | `findUserByPlayerId` | `self, playerId` | server-only | 1-12 |
| `DeliveryLogic` | `getCancelSentMailboxBlockMessage` | `self, user, node` | server-only | 1-43 |
| `DeliveryLogic` | `getCancelSentMailboxClientBlockMessage` | `self, node` | client | 1-40 |
| `DeliveryLogic` | `getDeliveryPayloadMeso` | `self, payload` | server-only | 1-8 |
| `DeliveryLogic` | `getExpireTextClient` | `self, node` | client | 1-35 |
| `DeliveryLogic` | `getOrCreateSendRequestKey` | `self, userId, signature` | server-only | 1-11 |
| `DeliveryLogic` | `getReceiveMailboxBlockMessage` | `self, user, node, allowExpiredItem` | server-only | 1-62 |
| `DeliveryLogic` | `getReceiveMailboxClientBlockMessage` | `self, node` | client | 1-9 |
| `DeliveryLogic` | `getSendItemBlockMessage` | `self, itemStack` | server-only | 1-47 |
| `DeliveryLogic` | `getUserSendMeso` | `self, user` | server-only | 1-12 |
| `DeliveryLogic` | `getUserSendSlotItemCount` | `self, user, itemId` | server-only | 1-19 |
| `DeliveryLogic` | `getUserSendSlots` | `self, user` | server-only | 1-12 |
| `DeliveryLogic` | `grantMailboxRewards` | `self, user, node, deliveryId` | server-only | 1-49 |
| `DeliveryLogic` | `grantPendingDeliveryCancel` | `self, user, pendingEntry, deliveryId` | server-only | 1-41 |
| `DeliveryLogic` | `hasDeliveryTradeOnceItem` | `self, node` | server-only | 1-24 |
| `DeliveryLogic` | `hasEnoughReceiveSpace` | `self, user, node, preserveTransferFlag` | server-only | 1-143 |
| `DeliveryLogic` | `hasEnoughReceiveSpaceClient` | `self, node` | client | 1-43 |
| `DeliveryLogic` | `hasReceivableMailbox` | `self, mailbox` | server-only | 1-13 |
| `DeliveryLogic` | `isAdminDeliverySenderValue` | `self, value` | server-only | 1-4 |
| `DeliveryLogic` | `isDeliveryBlockedMapId` | `self, mapid` | server-only | 1-5 |
| `DeliveryLogic` | `isDeliveryItemExpired` | `self, itemStack` | server-only | 1-15 |
| `DeliveryLogic` | `isDeliveryItemExpireSoon` | `self, itemStack` | server-only | 1-19 |
| `DeliveryLogic` | `isDeliveryNodeItemExpired` | `self, node` | server-only | 1-15 |
| `DeliveryLogic` | `isDeliveryNodeItemExpireSoon` | `self, node` | server-only | 1-15 |
| `DeliveryLogic` | `isDeliveryPetItem` | `self, itemStack` | server-only | 1-8 |
| `DeliveryLogic` | `isDeliveryReceivePendingStale` | `self, node` | server-only | 1-14 |
| `DeliveryLogic` | `isDeliverySentByCurrentPlayer` | `self, user, node` | server-only | 1-13 |
| `DeliveryLogic` | `isParcelOpenLimitedByUser` | `self, user` | client | 1-9 |
| `DeliveryLogic` | `logDeliverySendFailure` | `self, user, pendingEntry, reason, deliveryId` | server-only | 1-14 |
| `DeliveryLogic` | `makeDefaultDeliveryEquipInfo` | `self, itemId` | server-only | 1-19 |
| `DeliveryLogic` | `makeDeliveryReceiveEquipInfo` | `self, user, itemId, rawEquipInfo, preserveTransferFlag` | server-only | 1-52 |
| `DeliveryLogic` | `makeDeliveryTradeSN` | `self, deliveryId` | server-only | 1-4 |
| `DeliveryLogic` | `markDeliveryNodeDeletedByExpiredItem` | `self, user, node, userId` | server-only | 1-32 |
| `DeliveryLogic` | `normalizeMailboxNode` | `self, row, nowSec` | server-only | 1-116 |
| `DeliveryLogic` | `normalizeSentMailboxNode` | `self, row, nowSec` | server-only | 1-117 |
| `DeliveryLogic` | `notifyDeliverySendCompletedClient` | `self` | client | 1-7 |
| `DeliveryLogic` | `notifyDeliverySendStateUnknown` | `self, user, userId, message` | server-only | 1-15 |
| `DeliveryLogic` | `openDeliveryUIAfterPingClient` | `self` | client | 1-13 |
| `DeliveryLogic` | `openDeliveryUIClient` | `self` | client | 1-19 |
| `DeliveryLogic` | `parseDeliveryCreateAtUnixFromRow` | `self, row` | server-only | 1-31 |
| `DeliveryLogic` | `pushMailboxToClient` | `self, user` | server-only | 1-8 |
| `DeliveryLogic` | `receiveMailboxItem` | `self, user, itemData, sourceUserID, preserveTransferFlag` | server-only | 1-27 |
| `DeliveryLogic` | `recordDeliveryRemoveItemLogs` | `self, user, items` | server-only | 1-19 |
| `DeliveryLogic` | `recoverPendingCancelByUser` | `self, user, mailbox` | server-only | 1-60 |
| `DeliveryLogic` | `recoverPendingReceiveByUser` | `self, user, mailbox` | server-only | 1-43 |
| `DeliveryLogic` | `requestDeliverySendConfirmInfo` | `self, toName, memo, sendMeso, senderUserId` | server-only | 1-40 |
| `DeliveryLogic` | `requestMailbox` | `self, senderUserId` | server-only | 1-10 |
| `DeliveryLogic` | `requestMailboxByUser` | `self, user` | server-only | 1-3 |
| `DeliveryLogic` | `requestMailboxByUserInternal` | `self, user, showLoginNotice` | server-only | 1-48 |
| `DeliveryLogic` | `requestMailboxOnLoginByUser` | `self, user` | server-only | 1-11 |
| `DeliveryLogic` | `requestOpenDeliveryUI` | `self, senderUserId` | server-only | 1-42 |
| `DeliveryLogic` | `requestSendSlots` | `self, senderUserId` | server-only | 1-31 |
| `DeliveryLogic` | `requestSentMailbox` | `self, senderUserId` | server-only | 1-10 |
| `DeliveryLogic` | `requestSentMailboxByUser` | `self, user` | server-only | 1-3 |
| `DeliveryLogic` | `requestSentMailboxByUserInternal` | `self, user` | server-only | 1-38 |
| `DeliveryLogic` | `restoreDeliveryNodeToInventory` | `self, user, node, preserveTransferFlag` | server-only | 1-48 |
| `DeliveryLogic` | `restorePendingSendDraftByEntry` | `self, user, pendingEntry` | server-only | 1-47 |
| `DeliveryLogic` | `rollbackPendingSendByUser` | `self, userId, playerName, fallbackUser, alertMessage` | server-only | 1-85 |
| `DeliveryLogic` | `sendDeliveryItemTradeLogs` | `self, tradeSN, senderUserID, receiverUserID, moveType, items` | server-only | 1-30 |
| `DeliveryLogic` | `sendDeliveryNodeTradeLogs` | `self, tradeSN, senderUserID, receiverUserID, moveType, node, meso` | server-only | 1-31 |
| `DeliveryLogic` | `serializeDeliveryItemStack` | `self, stack` | server-only | 1-6 |
| `DeliveryLogic` | `setDeliveryInteractionBlockedClient` | `self, blocked` | client | 1-7 |
| `DeliveryLogic` | `setMailboxClient` | `self, mailbox` | client | 1-7 |
| `DeliveryLogic` | `setSendMesoClient` | `self, meso` | client | 1-7 |
| `DeliveryLogic` | `setSentMailboxClient` | `self, mailbox` | client | 1-7 |
| `DeliveryLogic` | `shouldPreserveAdminDeliveryFlag` | `self, node` | server-only | 1-8 |
| `DeliveryLogic` | `shouldSuppressDeliveryMeso` | `self, payload` | server-only | 1-10 |
| `DeliveryLogic` | `showDeliveryAlertClient` | `self, message` | client | 1-6 |
| `DeliveryLogic` | `showDeliveryArrivedFadeYesNoClient` | `self, senderName` | client | 1-14 |
| `DeliveryLogic` | `showDeliverySendConfirmClient` | `self, toName, receiverLevel, receiverJob, memo, sendMeso` | client | 1-33 |
| `DeliveryLogic` | `showReceivableMailboxFadeYesNoClient` | `self` | client | 1-13 |
| `DeliveryLogic` | `tryCancelSentMailbox` | `self, dataIndex, senderUserId` | server-only | 1-136 |
| `DeliveryLogic` | `tryDeleteAllReceivedMailbox` | `self, senderUserId` | server-only | 1-92 |
| `DeliveryLogic` | `tryDeleteMailbox` | `self, dataIndex, senderUserId` | server-only | 1-66 |
| `DeliveryLogic` | `tryDiscardMailbox` | `self, dataIndex, senderUserId` | server-only | 1-75 |
| `DeliveryLogic` | `tryReceiveMailbox` | `self, dataIndex, senderUserId` | server-only | 1-135 |
| `DeliveryLogic` | `tryReturnSendItem` | `self, slotId, senderUserId` | server-only | 1-52 |
| `DeliveryLogic` | `trySendDelivery` | `self, toName, memo, senderUserId` | server-only | 1-33 |
| `DeliveryLogic` | `trySendDeliveryAfterPingForUser` | `self, requestUserId, toName, memo` | server-only | 1-195 |
| `DeliveryLogic` | `trySetSendItem` | `self, invType, invSlot, slotId, count, senderUserId` | server-only | 1-59 |
| `DeliveryLogic` | `trySetSendMeso` | `self, targetMeso, senderUserId` | server-only | 1-38 |
| `DimensionMirror` | `cacheScriptFunc` | `self` | server-only | 1-12 |
| `DimensionMirror` | `unityPortal` | `self, player, udc` | server-only | 1-4 |
| `Dojang` | `addDojoClearPoints` | `self, player, floor, pointEligible` | server-only | 1-19 |
| `Dojang` | `applyCachedMyDojangDamageRankClient` | `self` | client | 1-11 |
| `Dojang` | `applyCachedMyDojangRankClient` | `self, rankMode` | client | 1-14 |
| `Dojang` | `applyDojangDamageRank` | `self, entries, errorMessage, page, total, rankMode` | client | 1-60 |
| `Dojang` | `applyDojangRank` | `self, entries, errorMessage, rankMode, total` | client | 1-55 |
| `Dojang` | `applyDojangRankAvatarClient` | `self, rank, entry, boardName` | client | 1-95 |
| `Dojang` | `applyDojangRankRows` | `self, entries, rankMode, page, total` | client | 1-30 |
| `Dojang` | `applyMyDojangDamageRank` | `self, entry, rankMode` | client | 1-8 |
| `Dojang` | `applyMyDojangRank` | `self, entry, rankMode` | client | 1-8 |
| `Dojang` | `beginDojangDamageTestWithBlockCheck` | `self, player, fs` | server-only | 1-49 |
| `Dojang` | `beginDojoEntryWithBlockCheck` | `self, player, practiceMode` | server-only | 1-85 |
| `Dojang` | `beltDialog` | `self, player, udc` | server-only | 1-43 |
| `Dojang` | `buildDojangDamageRankCacheEntries` | `self, list` | server-only | 1-23 |
| `Dojang` | `buildDojangRankCacheEntries` | `self, list` | server-only | 1-24 |
| `Dojang` | `buildDojangRankLook` | `self, player` | server-only | 1-31 |
| `Dojang` | `buildDojoRankRewardConfirmMessage` | `self, rewards` | server-only | 1-12 |
| `Dojang` | `buildDojoRankRewards` | `self, rankEntry, expireTime` | server-only | 1-16 |
| `Dojang` | `bumpDojangSearchGenerationClient` | `self, boardName` | client | 1-11 |
| `Dojang` | `cacheScriptFunc` | `self` | server-only | 1-43 |
| `Dojang` | `canGainDojoRankRewards` | `self, player, rewards` | server-only | 1-24 |
| `Dojang` | `claimDojoRankReward` | `self, player, udc` | server-only | 1-52 |
| `Dojang` | `clearCurrentDojoDrops` | `self, player` | server-only | 1-18 |
| `Dojang` | `clearDojangDamageRankBoardClient` | `self` | client | 1-14 |
| `Dojang` | `clearDojangDamageRankRowsClient` | `self, firstRow` | client | 1-10 |
| `Dojang` | `clearDojangRankBoardClient` | `self` | client | 1-21 |
| `Dojang` | `clearDojangSearchTextClient` | `self, boardName` | client | 1-14 |
| `Dojang` | `collectDojangBlockEquips` | `self, player` | server-only | 1-30 |
| `Dojang` | `collectDojangEquippedBlockItems` | `self, player` | server-only | 1-19 |
| `Dojang` | `composeDojangRankMode` | `self, period, job` | client | 1-5 |
| `Dojang` | `connectDojangDamageRankPageClient` | `self` | client | 1-36 |
| `Dojang` | `connectDojangRankTabsClient` | `self` | client | 1-42 |
| `Dojang` | `consumeDojangRankRequestQuota` | `self, player, action, refillPerSecond, burst` | server-only | 1-43 |
| `Dojang` | `createDojoRankRewardItemInfo` | `self, itemId, expireTime` | server-only | 1-19 |
| `Dojang` | `dojang_DPS` | `self, player` | server-only | 1-24 |
| `Dojang` | `dojang_enter` | `self, player, udc` | server-only | 1-36 |
| `Dojang` | `dojang_exit` | `self, player, udc, portal` | server-only | 1-19 |
| `Dojang` | `dojang_next` | `self, player, udc, portal` | server-only | 1-38 |
| `Dojang` | `dojang_up` | `self, player, udc, portal` | server-only | 1-22 |
| `Dojang` | `dummyDamageDialog` | `self, player, udc` | server-only | 1-41 |
| `Dojang` | `ensureDojangDamageRankCache` | `self, player, mode, callback` | server-only | 1-111 |
| `Dojang` | `ensureDojangRankCache` | `self, player, rankMode, callback` | server-only | 1-116 |
| `Dojang` | `ensureDojangRankFlushTimer` | `self` | server-only | 1-7 |
| `Dojang` | `ensureDojoRankRewardCache` | `self, weekId, callback` | server-only | 1-29 |
| `Dojang` | `ensureDojoRankRewardCacheFresh` | `self` | server-only | 1-14 |
| `Dojang` | `exitDojo` | `self, player` | server-only | 1-23 |
| `Dojang` | `fillDojangDamageRankRowClient` | `self, row, entry` | client | 1-27 |
| `Dojang` | `fillDojangRankRowClient` | `self, row, entry` | client | 1-30 |
| `Dojang` | `filterMissingDojoRankRewards` | `self, player, rewards` | server-only | 1-11 |
| `Dojang` | `finishDojoRankRewardCacheLoad` | `self, weekId, ok, payload` | server-only | 1-27 |
| `Dojang` | `flushDojangRankWeb` | `self` | server-only | 1-23 |
| `Dojang` | `formatDojangBlockLines` | `self, blocked` | server-only | 1-27 |
| `Dojang` | `formatDojangDamageNumber` | `self, value` | client | 1-10 |
| `Dojang` | `formatDojangRankGuild` | `self, guildName` | client | 1-6 |
| `Dojang` | `formatDojangRankTime` | `self, totalMs` | client | 1-8 |
| `Dojang` | `gainDojoRankRewards` | `self, player, rewards` | server-only | 1-19 |
| `Dojang` | `getDojangDamageRankCacheKey` | `self, player, mode` | server-only | 1-8 |
| `Dojang` | `getDojangMonthKey` | `self` | server-only | 1-5 |
| `Dojang` | `getDojangRankCacheKey` | `self, player, rankMode` | server-only | 1-8 |
| `Dojang` | `getDojangRankComboItemForJob` | `self, job` | client | 1-10 |
| `Dojang` | `getDojangRankExpectedPeriodStart` | `self, periodToken` | server-only | 1-16 |
| `Dojang` | `getDojangRankFloorColor` | `self, floor` | client | 1-11 |
| `Dojang` | `getDojangRankJobFilterList` | `self` | client | 1-39 |
| `Dojang` | `getDojangRankJobFromMode` | `self, rankMode` | client | 1-9 |
| `Dojang` | `getDojangRankJobGroup` | `self, job` | client | 1-8 |
| `Dojang` | `getDojangRankJobNameClient` | `self, job` | client | 1-4 |
| `Dojang` | `getDojangRankPeriod` | `self, rankMode` | client | 1-12 |
| `Dojang` | `getDojangRankPeriodOffset` | `self, rankMode` | client | 1-4 |
| `Dojang` | `getDojangRankScope` | `self, rankMode` | client | 1-4 |
| `Dojang` | `getDojangRankTotalPagesClient` | `self, total` | client | 1-5 |
| `Dojang` | `getDojangUnavailableEquipItemName` | `self, itemId` | server-only | 1-10 |
| `Dojang` | `getDojoClearPointReward` | `self, floor` | server-only | 1-21 |
| `Dojang` | `getDojoDailyEntryTryCount` | `self, player` | server-only | 1-12 |
| `Dojang` | `getDojoDamageMeterDisplaySkillID` | `self, skillID` | client | 1-10 |
| `Dojang` | `getDojoFieldSetByMap` | `self, mapid` | server-only | 1-7 |
| `Dojang` | `getDojoPoints` | `self, player` | server-only | 1-4 |
| `Dojang` | `getDojoRankRewardExpireTime` | `self` | server-only | 1-16 |
| `Dojang` | `getDojoWeekId` | `self` | server-only | 1-15 |
| `Dojang` | `getEquippedDojangUnavailableItemId` | `self, player` | server-only | 1-19 |
| `Dojang` | `getStageId` | `self, mapid` | client | 1-17 |
| `Dojang` | `hasDojoRankRewardItemById` | `self, player, itemId` | server-only | 1-24 |
| `Dojang` | `hasParty` | `self, player` | client | 1-4 |
| `Dojang` | `initDojangJobComboBoxClient` | `self, boardName` | client | 1-38 |
| `Dojang` | `initDojangSearchBtnClient` | `self, boardName` | client | 1-18 |
| `Dojang` | `isAllowedDojangRankJobFilter` | `self, job` | server-only | 1-11 |
| `Dojang` | `isCurrentDojangSearchRequestClient` | `self, boardName, requestMode, requestGeneration` | client | 1-13 |
| `Dojang` | `isDojangBlockEquipmentExcludedItem` | `self, itemId` | server-only | 1-12 |
| `Dojang` | `isDojangDamageEquipSwapBlockedServer` | `self, player, equip, itemId` | server-only | 1-28 |
| `Dojang` | `isDojangEquipSwapBlockedServer` | `self, player, equip, itemId` | server-only | 1-87 |
| `Dojang` | `isDojangRankCacheFresh` | `self, cache, periodToken` | server-only | 1-12 |
| `Dojang` | `isDojangRankCacheWeekCompatible` | `self, cache, periodToken` | server-only | 1-7 |
| `Dojang` | `isDojangRankPeriodStartCurrent` | `self, periodToken, periodStart` | server-only | 1-4 |
| `Dojang` | `isDojangUnavailableEquipItem` | `self, itemId` | server-only | 1-4 |
| `Dojang` | `isDojangUnavailableEquipSwapBlockedServer` | `self, player, itemId` | server-only | 1-13 |
| `Dojang` | `isDojoBattleFloorClient` | `self` | client | 1-12 |
| `Dojang` | `isDojoCleared` | `self, mapid` | server-only | 1-9 |
| `Dojang` | `isDojoInUse` | `self` | server-only | 1-23 |
| `Dojang` | `isDojoMidnightBlock` | `self` | server-only | 1-6 |
| `Dojang` | `isDojoMidnightBlockFrom` | `self, fromMinute` | server-only | 1-17 |
| `Dojang` | `isDojoPracticeInUse` | `self` | server-only | 1-14 |
| `Dojang` | `isDojoRankRewardItem` | `self, itemId` | server-only | 1-4 |
| `Dojang` | `isRestingSpot` | `self, mapid` | client | 1-4 |
| `Dojang` | `loadDojangDamageRankBoard` | `self, player, mode, page` | server-only | 1-26 |
| `Dojang` | `loadDojangRankBoard` | `self, player, rankMode` | server-only | 1-23 |
| `Dojang` | `loadMyDojangDamageRankCached` | `self, player, mode, callback` | server-only | 1-82 |
| `Dojang` | `loadMyDojangRankCached` | `self, player, rankMode, callback` | server-only | 1-84 |
| `Dojang` | `lobbyDialog` | `self, player, udc` | server-only | 1-110 |
| `Dojang` | `logDojangEquipment` | `self, player, action, ulid, itemId, month, reason, extra` | server-only | 1-13 |
| `Dojang` | `markDojoCmdSkillUsedClient` | `self, skillID` | client | 1-5 |
| `Dojang` | `normalizeDojangDamageRankMode` | `self, mode` | client | 1-5 |
| `Dojang` | `normalizeDojangRankMode` | `self, rankMode` | client | 1-5 |
| `Dojang` | `OnBeginPlay` | `self` | client | 1-15 |
| `Dojang` | `onDojangDamageRankPageClient` | `self, delta` | client | 1-13 |
| `Dojang` | `onDojangDamageRankTabClient` | `self, mode` | client | 1-17 |
| `Dojang` | `onDojangJobSelectedClient` | `self, boardName, job, jobName, preserveSearchRequest` | client | 1-37 |
| `Dojang` | `onDojangRankPageClient` | `self, delta` | client | 1-12 |
| `Dojang` | `onDojangRankSearchClient` | `self, boardName` | client | 1-19 |
| `Dojang` | `onDojangRankTabClient` | `self, rankMode` | client | 1-15 |
| `Dojang` | `onDojoCommandKeyDown` | `self, event` | client | 1-46 |
| `Dojang` | `OnUpdate` | `self, delta` | client | 1-23 |
| `Dojang` | `openDojangDamageRank` | `self` | client | 1-26 |
| `Dojang` | `openDojangRank` | `self` | client | 1-28 |
| `Dojang` | `openDojoDamageMeterBigClient` | `self` | client | 1-4 |
| `Dojang` | `openDojoDamageMeterBySizeClient` | `self, showBig, isDojoEntry` | client | 1-30 |
| `Dojang` | `openDojoDamageMeterClient` | `self` | client | 1-4 |
| `Dojang` | `openDojoDamageMeterMiniClient` | `self` | client | 1-16 |
| `Dojang` | `openDojoDamageMeterSmallClient` | `self` | client | 1-4 |
| `Dojang` | `openDojoGate` | `self, player` | server-only | 1-21 |
| `Dojang` | `playDojoCastLocal` | `self, skillID` | client | 1-33 |
| `Dojang` | `playDojoSkillHit` | `self, player, mob, skillID` | client | 1-16 |
| `Dojang` | `preloadDojoRankRewardCache` | `self` | server-only | 1-7 |
| `Dojang` | `prepareDojoDamageMeterClient` | `self` | client | 1-17 |
| `Dojang` | `proceedDojoEntry` | `self, player, practiceMode` | server-only | 1-31 |
| `Dojang` | `queueDojangRankWeb` | `self, request` | server-only | 1-25 |
| `Dojang` | `recordDojoDailyEntryTry` | `self, player` | server-only | 1-11 |
| `Dojang` | `recordDojoDamage` | `self, attacker, mob, skillID, delta, hitCount` | server-only | 1-42 |
| `Dojang` | `recordDojoDamageClient` | `self, skillID, delta, floorID, hitCount` | client | 1-32 |
| `Dojang` | `refreshDojoDamageMeterClient` | `self` | client | 1-90 |
| `Dojang` | `releaseDojoSlot` | `self, slotKey, uid` | server-only | 1-8 |
| `Dojang` | `renderDojangDamageRankTop5Client` | `self` | client | 1-14 |
| `Dojang` | `renderDojangRankTop5Client` | `self` | client | 1-16 |
| `Dojang` | `requestDojangBlockCheck` | `self, player, items, callback` | server-only | 1-24 |
| `Dojang` | `requestDojangDamageBlockCheck` | `self, player, items, callback` | server-only | 1-19 |
| `Dojang` | `requestDojangDamageRankingWeb` | `self, player, rankOffset, rankCount, mode, myOnly, callback` | server-only | 1-38 |
| `Dojang` | `requestDojangDamageRankPage` | `self, mode, page, senderUserId` | server-only | 1-17 |
| `Dojang` | `requestDojangDamageRankSearch` | `self, name, periodOffset, jobFilter, requestGeneration, senderUserId` | server-only | 1-33 |
| `Dojang` | `requestDojangRankingWeb` | `self, player, rankOffset, rankCount, rankMode, callback` | server-only | 1-41 |
| `Dojang` | `requestDojangRankPage` | `self, rankMode, page, senderUserId` | server-only | 1-34 |
| `Dojang` | `requestDojangRankSearch` | `self, name, periodOffset, jobFilter, requestGeneration, senderUserId` | server-only | 1-33 |
| `Dojang` | `requestDojangRankTab` | `self, rankMode, senderUserId` | server-only | 1-15 |
| `Dojang` | `requestDojoCommandSkill` | `self, dir, senderUserId` | server-only | 1-12 |
| `Dojang` | `resetDojoCmdSkillUsedClient` | `self` | client | 1-4 |
| `Dojang` | `resetDojoDamageClient` | `self` | client | 1-15 |
| `Dojang` | `resetDojoDamageMeterSessionClient` | `self, closeWindows` | client | 1-14 |
| `Dojang` | `restingDialog` | `self, player, udc, mapid` | server-only | 1-28 |
| `Dojang` | `searchDojangDamageRankByNameWeb` | `self, player, name, periodOffset, jobFilter, requestGeneration` | server-only | 1-81 |
| `Dojang` | `searchDojangRankByNameWeb` | `self, player, name, periodOffset, jobFilter, requestGeneration` | server-only | 1-85 |
| `Dojang` | `setDojangDamageRankTabVisualClient` | `self, mode` | client | 1-29 |
| `Dojang` | `setDojangRankJobCellClient` | `self, path, jobDisplayName, textColor` | client | 1-45 |
| `Dojang` | `setDojangRankTabVisualClient` | `self, rankMode` | client | 1-31 |
| `Dojang` | `setDojangRankTextClient` | `self, path, value` | client | 1-18 |
| `Dojang` | `setDojangRankTextColorClient` | `self, path, value, textColor` | client | 1-22 |
| `Dojang` | `setDojoDamageMeterMeasuringStateClient` | `self` | client | 1-15 |
| `Dojang` | `setDojoMeasurePausedClient` | `self, paused` | client | 1-23 |
| `Dojang` | `setDojoPoints` | `self, player, points` | server-only | 1-4 |
| `Dojang` | `shortenPortalCooldown` | `self, player` | server-only | 1-10 |
| `Dojang` | `shortenPortalCooldownClient` | `self` | client | 1-8 |
| `Dojang` | `showDojangDamageRankSearchResultClient` | `self, entry, scope, requestMode, requestGeneration` | client | 1-32 |
| `Dojang` | `showDojangRank` | `self, player` | server-only | 1-10 |
| `Dojang` | `showDojangRankSearchResultClient` | `self, entry, scope, requestMode, requestGeneration` | client | 1-34 |
| `Dojang` | `showDojangSearchErrorClient` | `self, boardName, message, requestMode, requestGeneration` | client | 1-6 |
| `Dojang` | `showDojoDamageMeter` | `self, player` | server-only | 1-7 |
| `Dojang` | `showDojoDamageMeterBig` | `self, player` | server-only | 1-7 |
| `Dojang` | `showDojoTaunt` | `self, msg` | client | 1-5 |
| `Dojang` | `showDummyDamageRanking` | `self, player` | server-only | 1-9 |
| `Dojang` | `sliceDojangRankCacheEntries` | `self, entries, startIndex, count` | server-only | 1-9 |
| `Dojang` | `startDojo` | `self, player, udc` | server-only | 1-79 |
| `Dojang` | `startDojoDamageTimerClient` | `self` | client | 1-14 |
| `Dojang` | `startDojoPractice` | `self, player, udc` | server-only | 1-38 |
| `Dojang` | `stopDojoDamageTimerClient` | `self` | client | 1-14 |
| `Dojang` | `storeMyDojangDamageRankCache` | `self, player, mode, myRow, periodStart` | server-only | 1-46 |
| `Dojang` | `storeMyDojangRankCache` | `self, player, rankMode, myRow, periodStart` | server-only | 1-40 |
| `Dojang` | `submitDojangDamageRankWeb` | `self, player, damage, items` | server-only | 1-48 |
| `Dojang` | `submitDojangRank` | `self, player, floor, clearTime, achievedAt` | server-only | 1-11 |
| `Dojang` | `submitDojangRankWeb` | `self, player, floor, clearTime, achievedAt` | server-only | 1-39 |
| `Dojang` | `tryClaimDojoSlot` | `self, slotKey, uid` | server-only | 1-18 |
| `Dojang` | `useDojoCommandSkillClient` | `self, dir` | client | 1-23 |
| `Dojang` | `warpInto` | `self, player, udc, mapid` | server-only | 1-5 |
| `DojoRaidUILogic` | `createFieldUI` | `self` | client | 1-23 |
| `DojoRaidUILogic` | `getDojangUIGroup` | `self` | client | 1-7 |
| `DojoRaidUILogic` | `hide` | `self` | client | 1-4 |
| `DojoRaidUILogic` | `hideLocal` | `self` | client | 1-11 |
| `DojoRaidUILogic` | `OnBeginPlay` | `self` | client | 1-5 |
| `DojoRaidUILogic` | `setEnergy` | `self, ratio` | client | 1-10 |
| `DojoRaidUILogic` | `setRemainingPotion` | `self, value` | client | 1-6 |
| `DojoRaidUILogic` | `setRemainingWheel` | `self, value` | client | 1-6 |
| `DojoRaidUILogic` | `setTime` | `self, seconds` | client | 1-8 |
| `DojoRaidUILogic` | `setTimeRemain` | `self, seconds` | client | 1-9 |
| `DojoRaidUILogic` | `show` | `self, monsterKey` | client | 1-24 |
| `DonationKingLogic` | `applyCurrentChallengeRecord` | `self, player, playerId, currentSeasonId, currentChallengeFound, currentChallenge` | server-only | 1-43 |
| `DonationKingLogic` | `applySnapshot` | `self, payload` | server-only | 1-99 |
| `DonationKingLogic` | `buildRankingText` | `self, rankers` | server-only | 1-36 |
| `DonationKingLogic` | `ensureCurrentSeason` | `self` | server-only | 1-3 |
| `DonationKingLogic` | `finishSnapshotRefresh` | `self, success` | server-only | 1-43 |
| `DonationKingLogic` | `formatDonationMeso` | `self, meso` | server-only | 1-19 |
| `DonationKingLogic` | `getClaimableRewardCount` | `self, player, callback` | server-only | 1-21 |
| `DonationKingLogic` | `getPreviousRankers` | `self, mapId` | server-only | 1-16 |
| `DonationKingLogic` | `getPreviousSeasonState` | `self` | server-only | 1-3 |
| `DonationKingLogic` | `getSnapshotRefreshJitterSeconds` | `self` | server-only | 1-11 |
| `DonationKingLogic` | `getTopRankers` | `self, mapId, maxCount` | server-only | 1-28 |
| `DonationKingLogic` | `getTownConfig` | `self, mapId` | server-only | 1-9 |
| `DonationKingLogic` | `getTownConfigs` | `self` | server-only | 1-3 |
| `DonationKingLogic` | `giveUpChallenge` | `self, player, callback` | server-only | 1-59 |
| `DonationKingLogic` | `handleStartChallengeResponse` | `self, playerId, seasonId, requestedMapId, callback, result, response` | server-only | 1-28 |
| `DonationKingLogic` | `invokeSnapshotCallbacks` | `self, callbacks, success` | server-only | 1-10 |
| `DonationKingLogic` | `isCurrentSeasonChallenge` | `self, player` | server-only | 1-7 |
| `DonationKingLogic` | `isSamePlayerEntity` | `self, player, playerId` | server-only | 1-7 |
| `DonationKingLogic` | `nextRequestKey` | `self, playerId, mapId` | server-only | 1-5 |
| `DonationKingLogic` | `nextRewardClaimLockKey` | `self, playerId` | server-only | 1-4 |
| `DonationKingLogic` | `OnBeginPlay` | `self` | server-only | 1-69 |
| `DonationKingLogic` | `OnEndPlay` | `self` | server-only | 1-28 |
| `DonationKingLogic` | `readCurrentRankingSnapshot` | `self, callback` | server-only | 1-54 |
| `DonationKingLogic` | `readSnapshotCache` | `self, callback` | server-only | 1-37 |
| `DonationKingLogic` | `recordSnapshotResult` | `self, success` | server-only | 1-19 |
| `DonationKingLogic` | `refreshSnapshot` | `self, callback` | server-only | 1-100 |
| `DonationKingLogic` | `refreshSnapshotIfStale` | `self, minIntervalSeconds, callback` | server-only | 1-16 |
| `DonationKingLogic` | `refreshSnapshotLatest` | `self, callback` | server-only | 1-22 |
| `DonationKingLogic` | `releaseClaimableReward` | `self, reservation` | server-only | 1-7 |
| `DonationKingLogic` | `requestDonation` | `self, player, mapId, amount, callback` | server-only | 1-445 |
| `DonationKingLogic` | `reserveClaimableReward` | `self, player, callback` | server-only | 1-73 |
| `DonationKingLogic` | `reserveDonationKingReviewLog` | `self, requestKey` | server-only | 1-13 |
| `DonationKingLogic` | `resetExpiredChallenge` | `self, player` | server-only | 1-17 |
| `DonationKingLogic` | `scheduleDonationCloseSnapshot` | `self, donationCloseAt` | server-only | 1-32 |
| `DonationKingLogic` | `scheduleSnapshotRefresh` | `self` | server-only | 1-28 |
| `DonationKingLogic` | `startChallenge` | `self, player, mapId, callback` | server-only | 1-42 |
| `DonationKingLogic` | `tryLockPlayerOperation` | `self, playerId` | server-only | 1-8 |
| `DonationKingLogic` | `tryLockRewardClaim` | `self, playerId, rewardLockKey` | server-only | 1-15 |
| `DonationKingLogic` | `unlockPlayerOperation` | `self, playerId` | server-only | 1-3 |
| `DonationKingLogic` | `unlockRewardClaim` | `self, playerId, rewardLockKey` | server-only | 1-5 |
| `DropItemLogic` | `canDropGoToFoothold` | `self, map, startPosition, targetX, targetY` | server-only | 1-14 |
| `DropItemLogic` | `canRestoreTradeAvailable` | `self, itemId` | server-only | 1-10 |
| `DropItemLogic` | `canTakeDrop` | `self, user, dropPool` | server-only | 1-26 |
| `DropItemLogic` | `canUseDedicatedDropOwnerId` | `self, user, ownerID` | client | 1-40 |
| `DropItemLogic` | `canUserPickupIcebox` | `self, user` | server-only | 1-7 |
| `DropItemLogic` | `canUserPickupMysteryCube` | `self, user` | server-only | 1-7 |
| `DropItemLogic` | `canUserSeeDedicatedDrop` | `self, user, dropPool` | client | 1-39 |
| `DropItemLogic` | `canUserSeeDrop` | `self, user, dropPool` | server-only | 1-12 |
| `DropItemLogic` | `createDrop` | `self, map, itemID, quantity, ownerID, ownPartyID, ownType, sourceID, sourceType, sourcePlayerName, curPos, x2, delay, byPet, iEquip, questId` | server-only | 1-151 |
| `DropItemLogic` | `createHDrop` | `self, map` | server-only | 1-47 |
| `DropItemLogic` | `getDedicatedDropPoolKey` | `self, map, ownerID, ownPartyID, sourceID` | client | 1-25 |
| `DropItemLogic` | `getPickupLogSourceType` | `self, dropSourceType` | server-only | 1-21 |
| `DropItemLogic` | `handlePickupDrop` | `self, id, pickedByPet, petId, hi, senderUserId` | server-only | 1-22 |
| `DropItemLogic` | `handlePickupDropItem` | `self, id, pickedByPet, petId, hi, senderUserId` | server-only | 1-22 |
| `DropItemLogic` | `handlePickupDropItemNew` | `self, id, pickedByPet, petId, hi, senderUserId` | server-only | 1-394 |
| `DropItemLogic` | `isConsumeOnPickupItem` | `self, itemId` | server-only | 1-3 |
| `DropItemLogic` | `isIceboxDropPool` | `self, dropPool` | server-only | 1-6 |
| `DropItemLogic` | `isIceboxItem` | `self, itemId` | server-only | 1-3 |
| `DropItemLogic` | `isMysteryCubeDropPool` | `self, dropPool` | server-only | 1-6 |
| `DropItemLogic` | `isMysteryCubeItem` | `self, itemId` | server-only | 1-3 |
| `DropItemLogic` | `isPrivateVisibleDropItem` | `self, itemId` | server-only | 1-3 |
| `DropItemLogic` | `makeDropTradeSN` | `self, dropID` | server-only | 1-6 |
| `DropItemLogic` | `normalizeDropSourceType` | `self, sourceType` | server-only | 1-7 |
| `DropItemLogic` | `removeDrop` | `self, map, dropID, leaveType, pickUpBy, explodeDelay, userId` | server-only | 1-13 |
| `DropItemLogic` | `sendMakeEnterFieldPacket` | `self, map, enterType, ctx, userId` | server-only | 1-6 |
| `DropItemLogic` | `sendMakeEnterFieldPacketToObservers` | `self, map, enterType, ctx, dropPool` | server-only | 1-23 |
| `DropItemLogic` | `sendMakeLeaveFieldPacket` | `self, map, dropID, leaveType, pickUpBy, explodeDelay, userId` | server-only | 1-21 |
| `DropItemLogic` | `sendPlayerDropTradeLog` | `self, dropPool, receiver, itemID, quantity, itemSN, equipInfo` | server-only | 1-37 |
| `DropItemLogic` | `setPickupEnabled` | `self, enabled` | client | 1-3 |
| `DropItemLogic` | `shouldHideQuestDropFromUser` | `self, user, dropPool` | server-only | 1-35 |
| `DropItemLogic` | `SyncVisibleDropsToObserver_ServerOnly` | `self, observedUser, observerUserId` | server-only | 1-19 |
| `DropItemLogic` | `tryPetPickupDrop` | `self, pet` | client | 1-71 |
| `DropItemLogic` | `tryPickupDrop` | `self` | client | 1-65 |
| `DualBlader00` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `DualBlader00` | `consume_2430071` | `self, player, udc` | server-only | 1-11 |
| `DualBlader00` | `dual_ballRoom` | `self, player, udc` | server-only | 1-9 |
| `DualBlader00` | `dual_blueAlcohol` | `self, player, udc` | server-only | 1-39 |
| `DualBlader00` | `dual_Diary` | `self, player, udc` | server-only | 1-41 |
| `DualBlader00` | `dual_lv20` | `self, player, udc` | server-only | 1-9 |
| `DualBlader00` | `dual_lv25` | `self, player, udc` | server-only | 1-9 |
| `DualBlader00` | `dual_lv30` | `self, player, udc` | server-only | 1-9 |
| `DualBlader00` | `Dual_moveGate` | `self, player, udc` | server-only | 1-9 |
| `DualBlader00` | `dual_secret` | `self, player, udc` | server-only | 1-25 |
| `DualBlader00` | `dual_wallpaper` | `self, player, udc` | server-only | 1-47 |
| `EffectManager` | `applySetEffectOffset` | `self, target` | client | 1-32 |
| `EffectManager` | `getDirection` | `self, path` | client | 1-3 |
| `EffectManager` | `getEffect` | `self, path` | client | 1-30 |
| `EffectManager` | `getMapEffect` | `self, path` | client | 1-30 |
| `EffectManager` | `getNode` | `self, path` | client | 1-31 |
| `EffectManager` | `getUIEffect` | `self, path` | client | 1-30 |
| `EffectManager` | `loadDirection` | `self` | client | 1-81 |
| `EffectManager` | `loadEffect` | `self` | client | 1-86 |
| `EffectManager` | `loadSetEff` | `self` | client | 1-65 |
| `EffectManager` | `loadSummonEff` | `self` | client | 1-22 |
| `EffectManager` | `playSetEffect` | `self, target, path, key, poolKey, isBackgrnd` | client | 1-82 |
| `EffectManager` | `playSetEffectList` | `self, target, setEffList` | client | 1-31 |
| `EffectManager` | `refreshSetEffectFacing` | `self, target, faceLeft` | client | 1-40 |
| `EffectManager` | `releaseSetEffect` | `self, target, key` | client | 1-14 |
| `EffectManager` | `setSetEffectProneOffset` | `self, target, proneOffsetY` | client | 1-20 |
| `EffectManager` | `syncSetEffectMotionOffset` | `self, target, offsetX, offsetY` | client | 1-21 |
| `EffectManager` | `updateEquipSetEffect` | `self, target, mswCody, hair` | client | 1-112 |
| `EquipManager` | `applyFixedPotential` | `self, inventoryEquip` | client | 1-17 |
| `EquipManager` | `calcEquipItemQuality` | `self, ieqp` | client | 1-43 |
| `EquipManager` | `calcMakerSkillDisassembleCost` | `self, ieqp, makeCost` | client | 1-26 |
| `EquipManager` | `canHavePotential` | `self, itemId` | client | 1-16 |
| `EquipManager` | `getAdditinalCrystalCategoryByItemID` | `self, itemID` | client | 1-25 |
| `EquipManager` | `getAttackSpeedLabel` | `self, value` | client | 1-3 |
| `EquipManager` | `getCategoryKoName` | `self, category` | client | 1-3 |
| `EquipManager` | `getCategoryKoNameById` | `self, itemId` | client | 1-4 |
| `EquipManager` | `getCategoryNameById` | `self, itemId` | client | 1-53 |
| `EquipManager` | `getEquipGradeColorAndMaterial` | `self, ieqp` | client | 1-23 |
| `EquipManager` | `getEquipmentSlotIdByItemId` | `self, itemId` | client | 1-12 |
| `EquipManager` | `getGrowthEquipMaxEXP` | `self, itemID, level` | client | 1-4 |
| `EquipManager` | `getGrowthEquipMaxLevel` | `self, itemID` | client | 1-7 |
| `EquipManager` | `getItemById` | `self, itemId` | client | 1-3 |
| `EquipManager` | `getLevelUpEquip` | `self, itemID` | client | 1-4 |
| `EquipManager` | `getLevelUpEquipLevelData` | `self, itemID, level` | client | 1-4 |
| `EquipManager` | `getPotentialGradeStr` | `self, grade` | client | 1-3 |
| `EquipManager` | `getReqGender` | `self, itemId` | client | 1-3 |
| `EquipManager` | `getReqGenderStr` | `self, itemId` | client | 1-8 |
| `EquipManager` | `getStringCategoryNameById` | `self, itemId` | client | 1-8 |
| `EquipManager` | `isBlade` | `self, itemId` | client | 1-7 |
| `EquipManager` | `isDragonEquip` | `self, itemId` | client | 1-5 |
| `EquipManager` | `isEquip` | `self, itemId` | client | 1-6 |
| `EquipManager` | `isGrowthEquip` | `self, itemID` | client | 1-7 |
| `EquipManager` | `isPotentialChangeBlockedEquip` | `self, itemId` | client | 1-4 |
| `EquipManager` | `isTwoHandedCashWeapon` | `self, itemID` | client | 1-43 |
| `EquipManager` | `isWeapon` | `self, itemID` | client | 1-4 |
| `EquipManager` | `loadCashWeaponTypeData` | `self` | client | 1-28 |
| `EquipManager` | `loadEquipData` | `self` | client | 1-47 |
| `EquipManager` | `loadEquipItemData` | `self, itemId, data` | client | 1-165 |
| `EquipManager` | `loadIcon` | `self, equip, info` | client | 1-35 |
| `EquipManager` | `tryMapping` | `self` | client | 1-151 |
| `EquipmentSlotType` | `isRing` | `self, slot` | client | 1-3 |
| `EtcManager` | `getItemMakeUIInfo` | `self, user` | client | 1-58 |
| `EtcManager` | `getMakableItemList` | `self, jobGroup, user, makableInfo, sortedCategory` | client | 1-46 |
| `EtcManager` | `getNode` | `self, path` | client | 1-26 |
| `EtcManager` | `getScriptInfo` | `self, scriptName` | client | 1-3 |
| `EtcManager` | `getSwindleWarning` | `self, input` | client | 1-48 |
| `EtcManager` | `getTip` | `self, job, level` | client | 1-52 |
| `EtcManager` | `loadEtc` | `self` | client | 1-42 |
| `EtcManager` | `parseItemMake` | `self` | client | 1-77 |
| `EtcManager` | `parseMakeCharInfo` | `self` | client | 1-22 |
| `EtcManager` | `parseScriptInfo` | `self` | client | 1-6 |
| `EtcManager` | `parseSwindle` | `self` | client | 1-27 |
| `EtcManager` | `parseTipsInfo` | `self` | client | 1-17 |
| `EventScript` | `cacheScriptFunc` | `self` | server-only | 1-17 |
| `EventScript` | `canGainIceboxReward` | `self, player, reward` | server-only | 1-28 |
| `EventScript` | `consumeIceboxItem` | `self, player, itemId` | server-only | 1-9 |
| `EventScript` | `createIceboxItemInfo` | `self, itemId, itemFlag, expTime, potential` | server-only | 1-33 |
| `EventScript` | `event_script` | `self, player, udc` | server-only | 1-714 |
| `EventScript` | `gainIceboxReward` | `self, player, reward` | server-only | 1-32 |
| `EventScript` | `getIceboxExpireTime` | `self` | server-only | 1-4 |
| `EventScript` | `getIceboxIcebarExpireTime` | `self` | server-only | 1-4 |
| `EventScript` | `getIceboxThirtyDayExpireTime` | `self` | server-only | 1-4 |
| `EventScript` | `getTestWorldSupportText` | `self` | server-only | 1-21 |
| `EventScript` | `hasIceboxOpenInventorySpace` | `self, player` | server-only | 1-16 |
| `EventScript` | `icebox` | `self, player, udc` | server-only | 1-30 |
| `EventScript` | `icebox1` | `self, player, udc` | server-only | 1-30 |
| `EventScript` | `isBestTesterRewardTarget` | `self, player` | server-only | 1-16 |
| `EventScript` | `isIceboxEventExpired` | `self` | server-only | 1-3 |
| `EventScript` | `isRecoverTargetSkill` | `self, player, skillData` | server-only | 1-28 |
| `EventScript` | `newPet` | `self, p, udc` | client | 1-4 |
| `EventScript` | `notifyIceboxEventExpired` | `self, player` | server-only | 1-5 |
| `EventScript` | `npc_9010000` | `self, player, udc` | server-only | 1-5 |
| `EventScript` | `openAranPassClient` | `self` | client | 1-19 |
| `EventScript` | `openDailyGiftClient` | `self` | client | 1-21 |
| `EventScript` | `premium_icebox_exchange` | `self, player, udc` | server-only | 1-77 |
| `EventScript` | `quest_script` | `self, player, udc` | server-only | 1-55 |
| `EventScript` | `recoverQuestTeachSkills` | `self, player, udc` | server-only | 1-59 |
| `EventScript` | `selectIcebox1Reward` | `self` | server-only | 1-68 |
| `EventScript` | `selectIceboxReward` | `self` | server-only | 1-49 |
| `ExtendedEffectService` | `applySkillEffectAlpha` | `self, effectObject, ownerEntity` | client | 1-18 |
| `ExtendedEffectService` | `broadcastSkillEffect` | `self, parent, skillID, key, faceLeft, z` | server-only | 1-7 |
| `ExtendedEffectService` | `effectTremble` | `self, player, trembleForce, heavyNShortTremble, delay, addEffectTime, enforceTremble, senderUserId` | server-only | 1-12 |
| `ExtendedEffectService` | `effectTrembleClient` | `self, trembleForce, heavyNShortTremble, delay, addEffectTime, enforceTremble` | client | 1-23 |
| `ExtendedEffectService` | `getMistCellKey` | `self, cx, cy` | client | 1-4 |
| `ExtendedEffectService` | `getMistCellPool` | `self, parent` | client | 1-23 |
| `ExtendedEffectService` | `getMistCountBlockedCells` | `self, pool, ownerGroup, cells` | client | 1-12 |
| `ExtendedEffectService` | `getSkillEffectAlpha` | `self, ownerEntity` | client | 1-37 |
| `ExtendedEffectService` | `makeEffect` | `self, parent, effect, pool, faceLeft, halfScale, loop, syncLayer, syncParent, z, position` | client | 1-54 |
| `ExtendedEffectService` | `makeExplosionAnimation` | `self, map, ea, pos, lt, rb, delay, ownerEntity` | client | 1-10 |
| `ExtendedEffectService` | `makeFallingAnimation` | `self, map, fa, pos, faceLeft, skillID, skillLevel, ownerEntity, rangeLt, rangeRb` | client | 1-9 |
| `ExtendedEffectService` | `makeFogEffect` | `self, parent, releasePool, ft, b, ownerEntity` | client | 1-112 |
| `ExtendedEffectService` | `makeFootholdEffect` | `self, map, fhEffect, pos, lt, rb, delay, ownerEntity` | client | 1-47 |
| `ExtendedEffectService` | `makeFootholdEffectGlobalXSpacing` | `self, map, fhEffect, pos, lt, rb, delay, maxCount, forcedEffectIndex, ownerEntity` | client | 1-132 |
| `ExtendedEffectService` | `makeSingleCenteredFogEffect` | `self, parent, releasePool, ft, b, ownerEntity` | client | 1-48 |
| `ExtendedEffectService` | `mistLtRbToCells` | `self, lt, rb, cellSize` | client | 1-19 |
| `ExtendedEffectService` | `mistShrinkLtRb` | `self, lt, rb, scale, outLtRb` | client | 1-21 |
| `ExtendedEffectService` | `playAnimationOnMap` | `self, map, anim, pos, a0, a1, duration, halfScale, loop, sortingLayer, orderInLayer, ownerEntity` | client | 1-55 |
| `ExtendedEffectService` | `playEffectAnimationLocal` | `self, path, animationType, scaleType, offset, loop, playRate, faceLeft, targetEntity, key, syncParentLayer, syncOrderInLayer` | client | 1-75 |
| `ExtendedEffectService` | `playEffectAnimationRemote` | `self, path, animationType, scaleType, offset, loop, playRate, faceLeft, parent, useTargetEntityPosition, targetEntity, key, syncParentLayer, syncOrderInLayer, senderUserId` | server-only | 1-12 |
| `ExtendedEffectService` | `playHlafSkillAnimationLocal` | `self, attacker, targetEntity, offset, animData, isFaceLeft` | client | 1-37 |
| `ExtendedEffectService` | `playSkillAfterimageLocal` | `self, targetEntity, data, playRate, offset, loop` | client | 1-26 |
| `ExtendedEffectService` | `playSkillAfterimageRemote` | `self, targetEntity, data, playRate, offset, loop, senderUserId` | server-only | 1-15 |
| `ExtendedEffectService` | `playSkillAnimationLocal` | `self, animationType, subType, id, effectIndex, targetEntity, playRate, offset, specialData, loop, isFaceLeft, keyName, forceBackLayer, ownerEntity` | client | 1-134 |
| `ExtendedEffectService` | `playSkillAnimationRemote` | `self, animationType, subType, id, effectIndex, targetEntity, playRate, offset, specialData, loop, isFaceLeft, keyName, forceBackLayer, ownerEntity, senderUserId` | server-only | 1-15 |
| `ExtendedEffectService` | `playSummonEffectLocal` | `self, targetEntity, data, offset` | client | 1-20 |
| `ExtendedEffectService` | `registerPart_Mist` | `self, parent, ownerGroup, ent, lt, rb, cellSize, skipVisibilityUpdate` | client | 1-24 |
| `ExtendedEffectService` | `removeGroup_Mist` | `self, parent, children` | client | 1-13 |
| `ExtendedEffectService` | `removePart_Mist` | `self, parent, ent` | client | 1-51 |
| `ExtendedEffectService` | `responseEnchantScroll` | `self, success, destroy` | client | 1-11 |
| `ExtendedEffectService` | `shouldHideRemotePlayerVisual` | `self, entity` | client | 1-10 |
| `ExtendedEffectService` | `shouldPlaySkillEffect` | `self, ownerEntity` | client | 1-6 |
| `ExtendedEffectService` | `showEffect` | `self, targetUser, type, data, remote` | server-only | 1-14 |
| `ExtendedEffectService` | `showEffect_general` | `self, parent, effect, faceLeft, z, halfScale, position, ownerEntity` | client | 1-37 |
| `ExtendedEffectService` | `showEffectClient` | `self, target, type, data` | client | 1-6 |
| `ExtendedEffectService` | `showSkillEffect` | `self, parent, skillID, key, faceLeft, z` | client | 1-39 |
| `ExtendedEffectService` | `showUserEffect` | `self, targetUser, type, remote` | server-only | 1-3 |
| `ExtendedEffectService` | `showUserEffectClient` | `self, targetUser, type` | client | 1-52 |
| `ExtendedEffectService` | `updateVisibleMist` | `self, pool, ent` | client | 1-30 |
| `ExtendedKeyboardKey` | `getKeyName` | `self, key` | client | 1-3 |
| `ExtendedKeyboardKey` | `OnBeginPlay` | `self` | client | 1-203 |
| `FadeYesNo` | `applyMobileFadeYesNoSpawnPosition` | `self, fade, offsetY` | client | 1-15 |
| `FadeYesNo` | `cleanupFadeYesNoEntry` | `self, entry, destroyEntity` | client | 1-33 |
| `FadeYesNo` | `closeFadeYesNoByKey` | `self, requestKey` | client | 1-17 |
| `FadeYesNo` | `createFadeYesNo` | `self, backgroundType, iconType, onlyCancelBtn, message, closeDuration, BtCallback, alignment, forceMSWPosX, requestKey` | client | 1-204 |
| `FadeYesNo` | `getAvailableFadeYesNoSlot` | `self` | client | 1-19 |
| `FadeYesNo` | `getFadeYesNoSpawnPosition` | `self, offsetY` | client | 1-13 |
| `FadeYesNo` | `getMobileFadeYesNoPosition` | `self, offsetY, halfWidth, halfHeight` | client | 1-45 |
| `FadeYesNo` | `resetFadeYesNo` | `self` | client | 1-12 |
| `FieldSetManager` | `enter` | `self, requester, fieldSet, transferOnlyOne` | server-only | 1-95 |
| `FieldSetManager` | `getFieldSet` | `self, fieldSet` | server-only | 1-3 |
| `FieldSetManager` | `loadFieldSet` | `self` | server-only | 1-98 |
| `FieldSetManager` | `OnEndPlay` | `self` | server-only | 1-7 |
| `FindMobLogic` | `checkMobInTrapezoid` | `self, x0, x1, x2, y, r, left, mob, finalBoxShape` | client | 1-34 |
| `FindMobLogic` | `findHitDazzledMobInRect` | `self, box, output, maxCount, owner` | client | 1-28 |
| `FindMobLogic` | `findHitMobByChainLightning` | `self, firstMob, output, maxCount, isFaceLeft, horizontalRange, owner` | client | 1-88 |
| `FindMobLogic` | `findHitMobInRect` | `self, box, output, maxCount, except, wishMobID, priorBuffID, wishTemplateID, includeDazzled, owner` | client | 1-66 |
| `FindMobLogic` | `findHitMobInTrapezoid` | `self, x0, x1, x2, y, r, output, left, finalBoxShape` | client | 1-33 |
| `FindMobLogic` | `findLiveMobPointInRect` | `self, mapLife, output, box, maxCount, except, excludeBoss, owner` | server-only | 1-32 |
| `FindMobLogic` | `findNearestMob` | `self, pos, dazzeld, owner` | client | 1-34 |
| `FindMobLogic` | `isRectIntersectWithTrapezoid` | `self, x0, x1, x2, y, r, left, b, finalBoxShape` | client | 1-34 |
| `FindMobLogic` | `makeBoxShape` | `self, origin, anchor, size, left, output` | client | 1-17 |
| `FontService` | `CalcFontWidth` | `self, fontType, text, bold, outline, minimap` | client | 1-95 |
| `FontService` | `CalcFontWidthHeight` | `self, fontType, pixelEntity, text, bold, outline, minimap` | client | 1-108 |
| `FontService` | `decodePixel2Bit` | `self, encoded, width` | client | 1-47 |
| `FontService` | `DrawText` | `self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor, isCentered, maxPixelWidth` | client | 1-166 |
| `FontService` | `DrawTextGUI` | `self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor, isRichText` | client | 1-168 |
| `FontService` | `DrawTextGUIAA` | `self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor` | client | 1-295 |
| `FontService` | `getCachedFontGlyph` | `self, fontType, unicodeValue, bold, outline` | client | 1-55 |
| `FontService` | `getCharWidth` | `self, char, bold, outline, fontType, gui` | client | 1-27 |
| `FontService` | `getEmptyCanvas` | `self, size` | client | 1-17 |
| `FontService` | `getStringToGulimHeight` | `self, text, maxPixelWidth, bold, outline` | client | 1-18 |
| `FontService` | `getStringWidth` | `self, text, bold, outline, fontType, _gui` | client | 1-28 |
| `FontService` | `GetUnicode` | `self, input` | client | 1-5 |
| `FontService` | `GetUTF8Length` | `self, input` | client | 1-7 |
| `FontService` | `splitTextByWidth` | `self, text, maxWidth, bold, outline, fontType, gui` | client | 1-50 |
| `FontService` | `wrapTextByPixelWidth` | `self, text, maxPixelWidth, bold, outline, fontType, gui` | client | 1-32 |
| `FootholdLogic` | `canGoThrough` | `self, map, startPos, hitPt, originFh` | client | 1-104 |
| `FootholdLogic` | `getCrossCandidate` | `self, map, x1, y1, x2, y2, output` | client | 1-30 |
| `FootholdLogic` | `getFootholdAbove_withDistance` | `self, map, x, y, yMax` | client | 1-8 |
| `FootholdLogic` | `getFootholdClosest` | `self, map, x, y, ptHitX` | client | 1-151 |
| `FootholdLogic` | `getFootholdRandom` | `self, map, count, range` | client | 1-37 |
| `FootholdLogic` | `getFootholdRange` | `self, map, x, y1, y2, output` | client | 1-33 |
| `FootholdLogic` | `getFootholdUnderneath` | `self, entity, offsetY` | client | 1-9 |
| `FootholdLogic` | `getFootholdUnderneath_withDistance` | `self, map, x, y, yMin` | client | 1-8 |
| `FootholdLogic` | `getFootholdUnderneathByPoint` | `self, map, x, y` | client | 1-8 |
| `FootholdLogic` | `getForwardLink` | `self, map, _fh, dir, x, len` | client | 1-38 |
| `FootholdLogic` | `getZMass` | `self, map, fhId` | client | 1-3 |
| `FootholdLogic` | `isBlockedArea` | `self, map, fhId1, fhId2, pos` | client | 1-20 |
| `FootholdLogic` | `isPointInMBR` | `self, map, x, y` | client | 1-8 |
| `FreeMarket` | `cacheScriptFunc` | `self` | server-only | 1-48 |
| `FreeMarket` | `inFreeMarket` | `self, player, udc` | server-only | 1-16 |
| `FreeMarket` | `market` | `self, player, udc` | server-only | 1-12 |
| `FreeMarket` | `market00` | `self, player, udc` | server-only | 1-15 |
| `GlobalRand32` | `new` | `self, s1, s2, s3` | client | 1-8 |
| `GlobalRand32` | `OnBeginPlay` | `self` | client | 1-6 |
| `GlobalRand32` | `random` | `self` | client | 1-19 |
| `GlobalRand32` | `randomDouble` | `self` | client | 1-3 |
| `GlobalRand32` | `randomDoubleRange` | `self, n1, n2` | client | 1-9 |
| `GlobalRand32` | `randomInteger` | `self` | client | 1-3 |
| `GlobalRand32` | `randomIntegerRange` | `self, n0, n1` | client | 1-20 |
| `GuildManager` | `addGuildMemberCacheServer` | `self, guildId, memberInfo` | server-only | 1-24 |
| `GuildManager` | `addGuildSkillPersonalInvestCountServer` | `self, user, guildId, skillId, amount` | server-only | 1-6 |
| `GuildManager` | `addGuildSkillPersonalUseCountServer` | `self, user, skillId, amount` | server-only | 1-6 |
| `GuildManager` | `addGuildSkillTotalPersonalInvestCountServer` | `self, user, guildId, skillId, amount` | server-only | 1-6 |
| `GuildManager` | `addMesoConsumeChatLog` | `self, user, meso` | server-only | 1-7 |
| `GuildManager` | `addMesoGainChatLog` | `self, user, meso` | server-only | 1-7 |
| `GuildManager` | `applyCurrentGuildMark` | `self, guildMark` | client | 1-17 |
| `GuildManager` | `applyGuildActiveBuffsServer` | `self, user` | server-only | 1-15 |
| `GuildManager` | `applyGuildCapacityChangedClient` | `self, guildId, capacity` | client | 1-28 |
| `GuildManager` | `applyGuildCapacityChangedToLocalGuildPlayers` | `self, guildId, capacity` | server-only | 1-22 |
| `GuildManager` | `applyGuildInfoClient` | `self, guildInfo` | client | 1-22 |
| `GuildManager` | `applyGuildInfoToLocalGuildPlayers` | `self, guildId` | server-only | 1-26 |
| `GuildManager` | `applyGuildInfoUIGuildMark` | `self` | client | 1-15 |
| `GuildManager` | `applyGuildInviteAcceptedResponseServer` | `self, guildId, guildInfo, user` | server-only | 1-23 |
| `GuildManager` | `applyGuildMarkChangedClient` | `self, guildId, guildMarkInfo` | client | 1-33 |
| `GuildManager` | `applyGuildMarkChangedToLocalGuildPlayers` | `self, guildId` | server-only | 1-27 |
| `GuildManager` | `applyGuildMarkSprite` | `self, target, childName, ruid` | client | 1-23 |
| `GuildManager` | `applyGuildMemberJoinedClient` | `self, guildId, joinedMemberInfo` | client | 1-31 |
| `GuildManager` | `applyGuildMemberJoinToLocalGuildPlayers` | `self, guildId, joinedPlayerId, joinedPlayerName, joinedMemberInfo` | server-only | 1-72 |
| `GuildManager` | `applyGuildMemberKickToLocalGuildPlayers` | `self, guildId, targetPlayerId, targetPlayerName` | server-only | 1-56 |
| `GuildManager` | `applyGuildMemberRankChangedClient` | `self, guildId, changedPlayerId, changedRankNo` | client | 1-31 |
| `GuildManager` | `applyGuildMemberRankChangedToLocalGuildPlayers` | `self, guildId, changedPlayerId, changedRankNo` | server-only | 1-20 |
| `GuildManager` | `applyGuildMemberRemovedClient` | `self, guildId, removedPlayerId` | client | 1-32 |
| `GuildManager` | `applyGuildMemberStatusChangedClient` | `self, guildId, changedPlayerId, online` | client | 1-52 |
| `GuildManager` | `applyGuildMemberStatusChangedToLocalGuildPlayers` | `self, guildId, changedPlayerId, online` | server-only | 1-35 |
| `GuildManager` | `applyGuildMemberWithdrawToLocalGuildPlayers` | `self, guildId, targetPlayerId, targetPlayerName` | server-only | 1-56 |
| `GuildManager` | `applyGuildNameTagSync` | `self, user, guildInfo` | server-only | 1-41 |
| `GuildManager` | `applyGuildNoticeChangedClient` | `self, guildId, guildNotice` | client | 1-45 |
| `GuildManager` | `applyGuildNoticeChangedToLocalGuildPlayers` | `self, guildId, guildNotice` | server-only | 1-26 |
| `GuildManager` | `applyGuildPassiveStatsServer` | `self, user, guildInfo` | server-only | 1-20 |
| `GuildManager` | `applyGuildRankNameChangedClient` | `self, guildId, rankNo, rankName` | client | 1-20 |
| `GuildManager` | `applyGuildRankNameChangedToLocalGuildPlayers` | `self, guildId, rankNo, rankName` | server-only | 1-20 |
| `GuildManager` | `applyGuildRemovedClient` | `self, guildId` | client | 1-23 |
| `GuildManager` | `applyGuildSkillChangedClient` | `self, guildId, guildSkillInfo` | client | 1-28 |
| `GuildManager` | `applyGuildSkillChangedToLocalGuildPlayers` | `self, guildId, changedSkillId, leveledSkillId, leveledSkillLevel, levelUpEventKey` | server-only | 1-30 |
| `GuildManager` | `applyNoGuildClient` | `self` | client | 1-28 |
| `GuildManager` | `buildGuildInfoForPlayerServer` | `self, guildInfo, user` | server-only | 1-12 |
| `GuildManager` | `buildGuildMarkPreloadRuidList` | `self` | client | 1-26 |
| `GuildManager` | `buildGuildPassiveBuffTooltipDescClient` | `self, guildSkillInfo` | client | 1-56 |
| `GuildManager` | `buildGuildSkillInfoForPlayerServer` | `self, guildId, guildSkillInfo, user` | server-only | 1-25 |
| `GuildManager` | `cacheGuildMarkBackGround` | `self, backGroundData` | client | 1-19 |
| `GuildManager` | `cacheGuildMarkMark` | `self, markData` | client | 1-55 |
| `GuildManager` | `calculateGuildPassiveStatsServer` | `self, guildInfo` | server-only | 1-26 |
| `GuildManager` | `canUseGuildActiveMoveInCurrentMapServer` | `self, user` | server-only | 1-36 |
| `GuildManager` | `cleanupStaleGuildSkillAccountKeysServer` | `self, user, currentGuildId` | server-only | 1-32 |
| `GuildManager` | `clearGuildActiveBossBuffServer` | `self, user` | server-only | 1-10 |
| `GuildManager` | `clearGuildActiveBuffsServer` | `self, user` | server-only | 1-16 |
| `GuildManager` | `clearGuildActiveBuffTimerServer` | `self, userId, playerId, skillId` | server-only | 1-12 |
| `GuildManager` | `clearGuildMembershipCacheForPlayerServer` | `self, playerId` | server-only | 1-37 |
| `GuildManager` | `clearGuildNoticeClient` | `self` | client | 1-28 |
| `GuildManager` | `clearGuildPassiveStatsServer` | `self, user` | server-only | 1-7 |
| `GuildManager` | `clearGuildUserRuntimeState` | `self, user` | server-only | 1-26 |
| `GuildManager` | `clearLocalGuildPlayer` | `self, guildId, playerId` | server-only | 1-11 |
| `GuildManager` | `cloneGuildTableServer` | `self, source` | server-only | 1-15 |
| `GuildManager` | `collectLocalGuildPlayersForDeltaServer` | `self, guildId` | server-only | 1-32 |
| `GuildManager` | `consumeGuildDeltaAppliedServer` | `self, eventKey` | server-only | 1-12 |
| `GuildManager` | `consumeGuildMemberLoginNotice` | `self, guildId, loginPlayerId` | server-only | 1-15 |
| `GuildManager` | `containsGuildNoticeProfanity` | `self, guildNotice` | client | 1-18 |
| `GuildManager` | `countGuildInfoMembersServer` | `self, guildInfo` | server-only | 1-9 |
| `GuildManager` | `countLocalGuildPlayers` | `self, guildId` | server-only | 1-15 |
| `GuildManager` | `decodeGuildBroadcastPayload` | `self, queue` | server-only | 1-20 |
| `GuildManager` | `deleteGuildActiveBuffExpireAccountKeysForGuildServer` | `self, user, guildId` | server-only | 1-22 |
| `GuildManager` | `deleteGuildSkillAccountKeysForGuildServer` | `self, user, guildId` | server-only | 1-16 |
| `GuildManager` | `dispatchGuildCapacityChangedRequest` | `self, guildId, payload` | server-only | 1-9 |
| `GuildManager` | `dispatchGuildDisbandedRequest` | `self, guildId, payload` | server-only | 1-3 |
| `GuildManager` | `dispatchGuildMarkChangedRequest` | `self, guildId, payload` | server-only | 1-8 |
| `GuildManager` | `dispatchGuildMemberJoinedRequest` | `self, guildId, payload` | server-only | 1-22 |
| `GuildManager` | `dispatchGuildMemberKickedRequest` | `self, guildId, payload` | server-only | 1-9 |
| `GuildManager` | `dispatchGuildMemberStatusChangedRequest` | `self, guildId, payload` | server-only | 1-35 |
| `GuildManager` | `dispatchGuildMemberWithdrawnRequest` | `self, guildId, payload` | server-only | 1-9 |
| `GuildManager` | `dispatchGuildNoticeChangedRequest` | `self, guildId, payload` | server-only | 1-11 |
| `GuildManager` | `dispatchGuildRankChangedRequest` | `self, guildId, payload` | server-only | 1-9 |
| `GuildManager` | `dispatchGuildRankNameChangedRequest` | `self, guildId, payload` | server-only | 1-9 |
| `GuildManager` | `dispatchGuildRequest` | `self, queue` | server-only | 1-50 |
| `GuildManager` | `dispatchGuildSkillChangedRequest` | `self, guildId, payload` | server-only | 1-14 |
| `GuildManager` | `drawGuildSkillInvestExpServer` | `self` | server-only | 1-17 |
| `GuildManager` | `ensureGuildRuntimeTables` | `self` | server-only | 1-33 |
| `GuildManager` | `executeGuildWhereClient` | `self, targetName` | client | 1-7 |
| `GuildManager` | `findCachedGuildIdByPlayerId` | `self, playerId` | server-only | 1-26 |
| `GuildManager` | `findGuildInviteTargetUser` | `self, targetName` | server-only | 1-13 |
| `GuildManager` | `findOnlineUserByPlayerNameServer` | `self, playerName` | server-only | 1-17 |
| `GuildManager` | `findUserEntityByPlayerId` | `self, playerId` | server-only | 1-13 |
| `GuildManager` | `finishGuildActiveSkillUseRequest` | `self, success, message, skillId, personalUseCount` | client | 1-14 |
| `GuildManager` | `finishGuildCreateRequest` | `self, success, message` | client | 1-14 |
| `GuildManager` | `finishGuildDisbandRequest` | `self, success, message` | client | 1-13 |
| `GuildManager` | `finishGuildKickRequest` | `self, success, changed, message` | client | 1-8 |
| `GuildManager` | `finishGuildMarkChangeRequest` | `self, success, message` | client | 1-16 |
| `GuildManager` | `finishGuildMemberRankChangeRequest` | `self, success, changed, message` | client | 1-8 |
| `GuildManager` | `finishGuildRankNameChangeRequest` | `self, success, changed, message` | client | 1-7 |
| `GuildManager` | `finishGuildSkillInvestRequest` | `self, success, message, skillId, personalInvestCount, meso` | client | 1-15 |
| `GuildManager` | `finishGuildWithdrawRequest` | `self, success, changed, message` | client | 1-8 |
| `GuildManager` | `getCachedGuildInfo` | `self, guildId` | server-only | 1-5 |
| `GuildManager` | `getCurrentMapIdServer` | `self, user` | server-only | 1-7 |
| `GuildManager` | `getGuildActiveBuffExpireAccountKey` | `self, guildId, playerId, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildActiveBuffExpireStorageKey` | `self, guildId, playerId, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildActiveBuffPlayerStorageKey` | `self, playerId` | server-only | 1-9 |
| `GuildManager` | `getGuildActiveBuffRemainSecServer` | `self, user, skillId` | server-only | 1-18 |
| `GuildManager` | `getGuildActiveSkillUseLimitServer` | `self, skillId, skillLevel` | server-only | 1-9 |
| `GuildManager` | `getGuildBossPlayerIdServer` | `self, guildInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildCacheKey` | `self, guildId` | server-only | 1-4 |
| `GuildManager` | `getGuildCapacityFromBroadcastPayloadServer` | `self, payload, guildInfo, fallbackCapacity` | server-only | 1-18 |
| `GuildManager` | `getGuildCapacityFromUserServer` | `self, user` | server-only | 1-9 |
| `GuildManager` | `getGuildDataForDeltaClient` | `self, guildId` | client | 1-33 |
| `GuildManager` | `getGuildEntity` | `self` | client | 1-9 |
| `GuildManager` | `getGuildIdFromBroadcastPayloadServer` | `self, payload` | server-only | 1-6 |
| `GuildManager` | `getGuildIdFromUserServer` | `self, user` | server-only | 1-20 |
| `GuildManager` | `getGuildInfoCapacityServer` | `self, guildInfo` | server-only | 1-14 |
| `GuildManager` | `getGuildInfoGuildId` | `self, guildInfo` | client | 1-7 |
| `GuildManager` | `getGuildInfoMarkInfo` | `self, guildInfo` | client | 1-60 |
| `GuildManager` | `getGuildInfoMembersServer` | `self, guildInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildInfoNotice` | `self, guildInfo` | client | 1-7 |
| `GuildManager` | `getGuildInfoSkillInfo` | `self, guildInfo` | client | 1-7 |
| `GuildManager` | `getGuildInfoSkillInfoServer` | `self, guildInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildInviteJobName` | `self, user` | server-only | 1-13 |
| `GuildManager` | `getGuildMarkMarkSize` | `self, category, code, color` | client | 1-37 |
| `GuildManager` | `getGuildMemberCacheByPlayerIdServer` | `self, guildInfo, playerId` | server-only | 1-19 |
| `GuildManager` | `getGuildMemberNameByPlayerIdServer` | `self, guildInfo, playerId` | server-only | 1-11 |
| `GuildManager` | `getGuildMemberPlayerIdServer` | `self, memberInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildMemberRankNoByPlayerIdServer` | `self, guildInfo, playerId` | server-only | 1-14 |
| `GuildManager` | `getGuildPassiveStatBonusServer` | `self, skillId, skillLevel` | server-only | 1-31 |
| `GuildManager` | `getGuildRankNameFromGuildDataClient` | `self, guildData, rankNo` | client | 1-25 |
| `GuildManager` | `getGuildRankNoFromUserServer` | `self, user` | server-only | 1-15 |
| `GuildManager` | `getGuildSkillAccountCleanupDateKey` | `self` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillInfoByIdServer` | `self, guildInfo, skillId` | server-only | 1-20 |
| `GuildManager` | `getGuildSkillInfoLevelClient` | `self, skillInfo` | client | 1-7 |
| `GuildManager` | `getGuildSkillInfoLevelServer` | `self, skillInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildSkillInfoSkillIdClient` | `self, skillInfo, fallbackSkillId` | client | 1-7 |
| `GuildManager` | `getGuildSkillInfoSkillIdServer` | `self, skillInfo` | server-only | 1-7 |
| `GuildManager` | `getGuildSkillInvestAccountKey` | `self, guildId, skillId, suffix` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillInvestStorageKey` | `self, guildId, skillId, suffix` | server-only | 1-8 |
| `GuildManager` | `getGuildSkillKeyGuildId` | `self, guildId` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillMaxLevelFromInfoServer` | `self, skillInfo, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillMaxLevelServer` | `self, skillId` | server-only | 1-10 |
| `GuildManager` | `getGuildSkillNameServer` | `self, skillId` | server-only | 1-15 |
| `GuildManager` | `getGuildSkillPersonalInvestCountServer` | `self, user, guildId, skillId` | server-only | 1-16 |
| `GuildManager` | `getGuildSkillPersonalUseCountServer` | `self, user, skillId` | server-only | 1-9 |
| `GuildManager` | `getGuildSkillTotalInvestAccountKey` | `self, guildId, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillTotalInvestStorageKey` | `self, guildId, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillTotalPersonalInvestCountServer` | `self, user, guildId, skillId` | server-only | 1-9 |
| `GuildManager` | `getGuildSkillUseDateQexKey` | `self` | server-only | 1-4 |
| `GuildManager` | `getGuildSkillUseQexKey` | `self, skillId` | server-only | 1-4 |
| `GuildManager` | `getGuildStatusInstanceId` | `self` | server-only | 1-8 |
| `GuildManager` | `getPlayerIdFromUser` | `self, user` | server-only | 1-11 |
| `GuildManager` | `getPlayerNameFromUser` | `self, user` | server-only | 1-7 |
| `GuildManager` | `getSelectedGuildMark` | `self` | client | 1-11 |
| `GuildManager` | `getUtf8CharacterCount` | `self, text` | client | 1-9 |
| `GuildManager` | `hasGuildCache` | `self, guildId` | server-only | 1-5 |
| `GuildManager` | `hasGuildMemberByPlayerIdServer` | `self, guildInfo, playerId` | server-only | 1-6 |
| `GuildManager` | `hasLocalPlayerGuild` | `self` | client | 1-8 |
| `GuildManager` | `hideGuildInfoUIGuildMark` | `self` | client | 1-7 |
| `GuildManager` | `initGuild` | `self, user, suppressLoginNotice` | server-only | 1-111 |
| `GuildManager` | `initGuildClient` | `self, guildInfo` | client | 1-46 |
| `GuildManager` | `isGuildInfoMemberNameServer` | `self, guildInfo, memberName` | server-only | 1-15 |
| `GuildManager` | `isGuildMemberOnlineByPlayerIdServer` | `self, guildInfo, playerId` | server-only | 1-6 |
| `GuildManager` | `isGuildMemberOnlineServer` | `self, guildMember` | server-only | 1-19 |
| `GuildManager` | `isGuildSkillAccountGuildTouchedToday` | `self, user, guildId, today` | server-only | 1-12 |
| `GuildManager` | `isValidGuildMarkSelectionServer` | `self, category, backGroundCode, backGroundColor, markCode, markColor` | server-only | 1-30 |
| `GuildManager` | `loadGuildMark` | `self` | client | 1-27 |
| `GuildManager` | `logGuildActionServer` | `self, actorUser, action2, guildId, guildInfo, targetPlayerId, targetName, details` | server-only | 1-14 |
| `GuildManager` | `markGuildDeltaAppliedServer` | `self, eventKey` | server-only | 1-8 |
| `GuildManager` | `notifyGuildMemberLogin` | `self, guildId, loginPlayerId, loginPlayerName` | server-only | 1-34 |
| `GuildManager` | `notifyGuildRankChanged` | `self, guildId, message` | server-only | 1-16 |
| `GuildManager` | `notifyGuildSkillLevelUp` | `self, guildId, skillId, skillLevel, eventKey` | server-only | 1-27 |
| `GuildManager` | `OnEndPlay` | `self` | server-only | 1-21 |
| `GuildManager` | `onGuildPlayerLeave` | `self, user` | server-only | 1-31 |
| `GuildManager` | `preloadGuildMarkResources` | `self` | client | 1-20 |
| `GuildManager` | `preserveGuildMemberOnlineStates` | `self, oldGuildInfo, newGuildInfo` | server-only | 1-27 |
| `GuildManager` | `preserveLocalGuildMemberOnlineStates` | `self, guildId, guildInfo` | server-only | 1-16 |
| `GuildManager` | `publishGuildMemberLoginLocal` | `self, guildId, loginPlayerId, loginPlayerName` | server-only | 1-12 |
| `GuildManager` | `pushGuildMarkPreloadRuid` | `self, ruidList, exists, ruidPath` | client | 1-17 |
| `GuildManager` | `pushGuildNameToStatUI` | `self, user, guildName` | server-only | 1-7 |
| `GuildManager` | `rebuildGuildMemberIndexServer` | `self, guildId, guildInfo` | server-only | 1-18 |
| `GuildManager` | `rebuildGuildSkillIndexServer` | `self, guildId, guildInfo` | server-only | 1-19 |
| `GuildManager` | `refreshGuildInfoAfterInviteAcceptedServer` | `self, user, expectedGuildId, requestPlayerId, requesterUserId` | server-only | 1-35 |
| `GuildManager` | `refreshGuildMemberDeltaClient` | `self, guildData` | client | 1-25 |
| `GuildManager` | `refreshGuildPassiveBuffIconClient` | `self, guildSkillInfo` | client | 1-12 |
| `GuildManager` | `removeGuildMemberCacheServer` | `self, guildId, playerId` | server-only | 1-19 |
| `GuildManager` | `requestGuildActiveSkillUse` | `self, skillId, targetName, senderUserId` | server-only | 1-158 |
| `GuildManager` | `requestGuildCapacityIncreaseFromNpc` | `self, user` | server-only | 1-100 |
| `GuildManager` | `requestGuildCreate` | `self, guildName, senderUserId` | server-only | 1-9 |
| `GuildManager` | `requestGuildCreateFromNpc` | `self, user, guildName` | server-only | 1-8 |
| `GuildManager` | `requestGuildCreateServer` | `self, user, guildName, requesterUserId` | client | 1-109 |
| `GuildManager` | `requestGuildDisbandFromNpc` | `self, user` | server-only | 1-46 |
| `GuildManager` | `requestGuildMarkChange` | `self, guildId, backGroundCode, backGroundColor, markCategory, markCode, markColor, senderUserId` | server-only | 1-118 |
| `GuildManager` | `requestGuildMemberInvite` | `self, guildId, targetName, senderUserId` | server-only | 1-84 |
| `GuildManager` | `requestGuildMemberKick` | `self, guildId, targetPlayerId, senderUserId` | server-only | 1-97 |
| `GuildManager` | `requestGuildMemberRankChange` | `self, guildId, targetPlayerId, direction, senderUserId` | server-only | 1-110 |
| `GuildManager` | `requestGuildMemberStatusChanged` | `self, guildId, playerId, playerName, online, isWarpLogin` | server-only | 1-4 |
| `GuildManager` | `requestGuildMemberStatusChangedRetry` | `self, guildId, playerId, playerName, online, isWarpLogin, retryCount` | server-only | 1-36 |
| `GuildManager` | `requestGuildMemberWithdraw` | `self, guildId, senderUserId` | server-only | 1-74 |
| `GuildManager` | `requestGuildNoticeChange` | `self, guildId, guildNotice, senderUserId` | server-only | 1-81 |
| `GuildManager` | `requestGuildRankNameChange` | `self, guildId, rankNames, senderUserId` | server-only | 1-108 |
| `GuildManager` | `requestGuildSkillInvest` | `self, skillId, senderUserId` | server-only | 1-153 |
| `GuildManager` | `requestGuildWhere` | `self, targetName, senderUserId` | server-only | 1-36 |
| `GuildManager` | `resetAllGuildSkillPersonalInvestCountsServer` | `self, user` | server-only | 1-20 |
| `GuildManager` | `resetAllGuildSkillPersonalUseCountsServer` | `self, user` | server-only | 1-18 |
| `GuildManager` | `resetGuildSkillPersonalUseCountsIfNeedServer` | `self, user` | server-only | 1-15 |
| `GuildManager` | `responseGuildInvite` | `self, accept, guildId, inviterPlayerId, targetPlayerId, senderUserId` | server-only | 1-95 |
| `GuildManager` | `scheduleGuildActiveBuffExpireServer` | `self, user, skillId, remainSec` | server-only | 1-32 |
| `GuildManager` | `setCurrentGuildMarkInfo` | `self, guildInfo` | client | 1-13 |
| `GuildManager` | `setGuildActiveBuffExpireTimeServer` | `self, user, skillId, expireMs` | server-only | 1-18 |
| `GuildManager` | `setGuildCache` | `self, guildId, guildInfo` | server-only | 1-23 |
| `GuildManager` | `setGuildCapacityCacheServer` | `self, guildId, capacity` | server-only | 1-14 |
| `GuildManager` | `setGuildInfoMyRankForPlayer` | `self, guildInfo, playerId` | server-only | 1-7 |
| `GuildManager` | `setGuildMarkInfoCacheServer` | `self, guildId, guildMarkInfo` | server-only | 1-8 |
| `GuildManager` | `setGuildMemberOnlineState` | `self, guildInfo, playerId, online` | server-only | 1-11 |
| `GuildManager` | `setGuildMemberRankCacheServer` | `self, guildId, playerId, rankNo` | server-only | 1-13 |
| `GuildManager` | `setGuildNoticeCacheServer` | `self, guildId, guildNotice` | server-only | 1-8 |
| `GuildManager` | `setGuildRankNameCacheServer` | `self, guildId, rankNo, rankName` | server-only | 1-34 |
| `GuildManager` | `setGuildRankNameInGuildDataClient` | `self, guildData, rankNo, rankName` | client | 1-31 |
| `GuildManager` | `setGuildSkillInfoCacheServer` | `self, guildId, guildSkillInfo` | server-only | 1-33 |
| `GuildManager` | `setGuildSkillPersonalInvestCountServer` | `self, user, guildId, skillId, count` | server-only | 1-10 |
| `GuildManager` | `setGuildSkillPersonalUseCountServer` | `self, user, skillId, count` | server-only | 1-10 |
| `GuildManager` | `setGuildSkillTotalPersonalInvestCountServer` | `self, user, guildId, skillId, count` | server-only | 1-8 |
| `GuildManager` | `setLocalGuildPlayer` | `self, guildId, playerId, user` | server-only | 1-13 |
| `GuildManager` | `showGuildCreateNameInput` | `self` | client | 1-17 |
| `GuildManager` | `showGuildInviteFadeYesNo` | `self, inviterLevel, inviterJobName, inviterName, guildId, inviterPlayerId, targetPlayerId` | client | 1-9 |
| `GuildManager` | `showGuildMemberLoginNotice` | `self, playerName` | client | 1-14 |
| `GuildManager` | `showGuildRankChangedChatClient` | `self, memberName, rankName` | client | 1-12 |
| `GuildManager` | `showGuildSkillLevelUpChat` | `self, skillId, skillLevel` | client | 1-14 |
| `GuildManager` | `syncGuildActiveBuffIconsClient` | `self, expRemainSec, bossRemainSec` | client | 1-27 |
| `GuildManager` | `syncGuildSkillMesoClient` | `self, meso` | client | 1-7 |
| `GuildManager` | `trimGuildInviteName` | `self, targetName` | server-only | 1-7 |
| `GuildManager` | `tryAcquireGuildWhereCooldownServer` | `self, userId` | server-only | 1-17 |
| `GuildManager` | `tryLockGuildActiveSkillUseServer` | `self, userId, skillId` | server-only | 1-12 |
| `GuildManager` | `unlockGuildActiveSkillUseServer` | `self, userId, skillId` | server-only | 1-8 |
| `GuildManager` | `upsertGuildSkillInfoClient` | `self, guildData, skillInfo` | client | 1-26 |
| `GuildManager` | `validateGuildNameText` | `self, guildName` | client | 1-18 |
| `GuildManager` | `validateGuildRankNameText` | `self, rankName` | client | 1-21 |
| `GuildScript` | `applyMakeMarkComboBoxSkin` | `self, comboBox, comboBoxType` | client | 1-42 |
| `GuildScript` | `applyMakeMarkComboBoxTransform` | `self, comboBox` | client | 1-9 |
| `GuildScript` | `applyMakeMarkPreviewMarkNativeSize` | `self` | client | 1-4 |
| `GuildScript` | `bindMakeMarkCategoryComboBox` | `self, comboBox` | client | 1-15 |
| `GuildScript` | `bindMakeMarkCategoryListItems` | `self, comboBox` | client | 1-29 |
| `GuildScript` | `bindMakeMarkSelectButton` | `self, path, kind, direction` | client | 1-11 |
| `GuildScript` | `buildMakeMarkCodeList` | `self, category` | client | 1-32 |
| `GuildScript` | `cacheScriptFunc` | `self` | server-only | 1-13 |
| `GuildScript` | `cycleMakeMarkValue` | `self, value, direction, minValue, maxValue` | client | 1-11 |
| `GuildScript` | `ensureMakeMarkActionButtons` | `self` | client | 1-21 |
| `GuildScript` | `ensureMakeMarkCategoryComboBox` | `self, parent, comboBoxType` | client | 1-34 |
| `GuildScript` | `ensureMakeMarkSelectionButtons` | `self` | client | 1-16 |
| `GuildScript` | `formatMakeMarkCode` | `self, code` | client | 1-4 |
| `GuildScript` | `getDefaultMakeMarkCode` | `self, category` | client | 1-13 |
| `GuildScript` | `getFirstMakeMarkCode` | `self, category` | client | 1-8 |
| `GuildScript` | `getLocalMakeMarkGuildId` | `self` | client | 1-16 |
| `GuildScript` | `getMakeMarkBackgrndAnimation` | `self` | client | 1-15 |
| `GuildScript` | `getMakeMarkCategoryByDisplayName` | `self, displayName` | client | 1-13 |
| `GuildScript` | `getMakeMarkCategoryByParam` | `self, param` | client | 1-13 |
| `GuildScript` | `getMakeMarkCodeList` | `self, category` | client | 1-8 |
| `GuildScript` | `getValidMarkColor` | `self, color` | client | 1-9 |
| `GuildScript` | `guild_mark` | `self, player, udc` | server-only | 1-7 |
| `GuildScript` | `guild_mark_` | `self, player, udc` | server-only | 1-21 |
| `GuildScript` | `guild_proc` | `self, player, udc` | server-only | 1-6 |
| `GuildScript` | `guild_proc_` | `self, player, udc` | server-only | 1-79 |
| `GuildScript` | `guild_union` | `self, player, udc` | server-only | 1-7 |
| `GuildScript` | `moveMakeMarkCode` | `self, category, currentCode, direction` | client | 1-23 |
| `GuildScript` | `onClickMakeMarkAgree` | `self` | client | 1-9 |
| `GuildScript` | `onClickMakeMarkDisagree` | `self` | client | 1-7 |
| `GuildScript` | `onMakeMarkCategorySelected` | `self, entryName` | client | 1-14 |
| `GuildScript` | `onMakeMarkSelectButton` | `self, kind, direction` | client | 1-15 |
| `GuildScript` | `openMakeMarkUI` | `self` | client | 1-68 |
| `GuildScript` | `preloadMakeMarkResources` | `self` | client | 1-6 |
| `GuildScript` | `prepareMakeMarkCodeCache` | `self` | client | 1-9 |
| `GuildScript` | `requestMakeMarkSave` | `self` | client | 1-21 |
| `GuildScript` | `resetMakeMarkSelection` | `self` | client | 1-9 |
| `GuildScript` | `resizeMakeMarkPreviewMark` | `self` | client | 1-24 |
| `GuildScript` | `setMakeMarkComboBoxTitle` | `self, comboBox, text` | client | 1-26 |
| `GuildScript` | `setupMakeMarkCategoryComboBoxItems` | `self, comboBox` | client | 1-20 |
| `GuildScript` | `showMakeMarkBackgrnd` | `self` | client | 1-28 |
| `GuildScript` | `updateMakeMarkPreview` | `self` | client | 1-18 |
| `GuildSkillLogic` | `createActiveRequiredExpByLevel` | `self` | client | 1-7 |
| `GuildSkillLogic` | `createGuildSkillConfig` | `self, skillIndex` | client | 1-117 |
| `GuildSkillLogic` | `createPassiveRequiredExpByLevel` | `self` | client | 1-10 |
| `GuildSkillLogic` | `createRequiredMesoByLevel` | `self` | client | 1-11 |
| `GuildSkillLogic` | `getGuildPassiveSkillEffectText` | `self, skillIndex, skillLevel` | client | 1-34 |
| `GuildSkillLogic` | `getGuildSkillConfig` | `self, skillIndex` | client | 1-5 |
| `GuildSkillLogic` | `getGuildSkillConfigList` | `self` | client | 1-7 |
| `GuildSkillLogic` | `getGuildSkillCount` | `self` | client | 1-5 |
| `GuildSkillLogic` | `getGuildSkillDescription` | `self, skillIndex, skillLevel` | client | 1-34 |
| `GuildSkillLogic` | `getGuildSkillDescriptionWithUseCount` | `self, skillIndex, skillLevel, personalUseCount` | client | 1-19 |
| `GuildSkillLogic` | `getGuildSkillLevelEffectText` | `self, skillIndex, skillLevel` | client | 1-32 |
| `GuildSkillLogic` | `getGuildSkillName` | `self, skillIndex` | client | 1-8 |
| `GuildSkillLogic` | `getLimitInvestCount` | `self, skillIndex` | client | 1-8 |
| `GuildSkillLogic` | `getMaxSkillLevel` | `self, skillIndex` | client | 1-8 |
| `GuildSkillLogic` | `getRequiredExp` | `self, skillIndex, skillLevel` | client | 1-8 |
| `GuildSkillLogic` | `getRequiredMeso` | `self, skillIndex, skillLevel` | client | 1-14 |
| `GuildSkillLogic` | `getTotalRequiredExp` | `self, skillIndex` | client | 1-12 |
| `GuildSkillLogic` | `initGuildSkillConfig` | `self` | client | 1-7 |
| `GuildSkillLogic` | `isActiveSkill` | `self, skillIndex` | client | 1-5 |
| `GuildSkillLogic` | `isPassiveSkill` | `self, skillIndex` | client | 1-5 |
| `GuildSkillLogic` | `OnBeginPlay` | `self` | client | 1-4 |
| `HitAni` | `createDefault` | `self, skillID, charLevel, SLV, weaponItemID, action, mobCount, bulletItemID` | client | 1-44 |
| `HitAni` | `createFirst` | `self, skillID, mobCount` | client | 1-12 |
| `HitAni` | `createHitAni` | `self, skillID, charLevel, SLV, weaponItemID, action, mobCount, attackInfo, bulletItemID` | client | 1-13 |
| `HitAni` | `createMultipleLayer` | `self, skillID, idx` | client | 1-3 |
| `HitAni` | `createShuffle` | `self, skillID, SLV, mobCount` | client | 1-12 |
| `HitAni` | `get_weapon_type` | `self, itemID` | client | 1-12 |
| `HitAni` | `is_correct_bullet_cashitem` | `self, weaponItemID, itemID` | client | 1-7 |
| `HitAni` | `is_final_action` | `self, action` | client | 1-3 |
| `Hontale0` | `cacheScriptFunc` | `self` | server-only | 1-39 |
| `Hontale0` | `getAvailableHontaleSlot` | `self` | server-only | 1-14 |
| `Hontale0` | `getCurrentHontaleEnterFieldSetByMapId` | `self, mapId` | server-only | 1-13 |
| `Hontale0` | `getCurrentHontaleSlotByMapId` | `self, mapId` | server-only | 1-8 |
| `Hontale0` | `getHontaleBossFieldSet` | `self, slot` | server-only | 1-11 |
| `Hontale0` | `getHontaleBossFieldSetName` | `self, slot` | server-only | 1-11 |
| `Hontale0` | `getHontaleBossMapId` | `self, slot` | server-only | 1-11 |
| `Hontale0` | `getHontaleEnterFieldSet` | `self, slot` | server-only | 1-11 |
| `Hontale0` | `getHontaleMasterSlotByName` | `self, name` | server-only | 1-23 |
| `Hontale0` | `getHontaleRegField` | `self, mapId` | server-only | 1-3 |
| `Hontale0` | `getHontaleSlotByMapId` | `self, mapId` | server-only | 1-19 |
| `Hontale0` | `getHontaleSlotStatusText` | `self, enterStarted, bossStarted` | server-only | 1-11 |
| `Hontale0` | `getStrReg` | `self, mapId, reg` | server-only | 1-4 |
| `Hontale0` | `hontale_accept` | `self, p, udc` | server-only | 1-339 |
| `Hontale0` | `hontale_ban` | `self, p, udc` | server-only | 1-49 |
| `Hontale0` | `hontale_ban2` | `self, p, name, udc` | server-only | 1-56 |
| `Hontale0` | `hontale_bancheck` | `self, mapId, cName` | server-only | 1-9 |
| `Hontale0` | `hontale_banned` | `self, mapId, cName, udc` | server-only | 1-11 |
| `Hontale0` | `hontale_check` | `self, mapId, cName` | server-only | 1-9 |
| `Hontale0` | `hontale_clearReg` | `self, mapId` | server-only | 1-56 |
| `Hontale0` | `hontale_entercheck` | `self, p, isNormal` | server-only | 1-23 |
| `Hontale0` | `hontale_entercheck2` | `self, mapId, udc` | server-only | 1-9 |
| `Hontale0` | `hontale_enterMsg` | `self, mapId` | server-only | 1-8 |
| `Hontale0` | `hontale_expeditionEndMsg` | `self, mapId` | server-only | 1-9 |
| `Hontale0` | `hontale_getname` | `self, mapId, udc` | server-only | 1-14 |
| `Hontale0` | `hontale_in` | `self, mapId, cName, udc` | server-only | 1-40 |
| `Hontale0` | `hontale_master` | `self, p, udc` | server-only | 1-10 |
| `Hontale0` | `hontale_noban` | `self, p, udc` | server-only | 1-46 |
| `Hontale0` | `hontale_out2` | `self, mapId, cName, udc` | server-only | 1-99 |
| `Hontale0` | `hontale_partycheck` | `self, p, udc, isNormal` | server-only | 1-15 |
| `Hontale0` | `hontale_reset` | `self, mapId` | server-only | 1-10 |
| `Hontale0` | `hontale_resetPassed` | `self, cTime, lTime, isNormal` | server-only | 1-11 |
| `Hontale0` | `hontale_temp` | `self, p, udc, portal` | server-only | 1-18 |
| `Hontale0` | `hontale_timecheck` | `self, p, udc, isNormal` | server-only | 1-23 |
| `Hontale0` | `isHontaleSlotAvailable` | `self, slot` | server-only | 1-8 |
| `Hontale0` | `normalizeHontaleRegMapId` | `self, mapId` | server-only | 1-11 |
| `Hontale0` | `setStrReg` | `self, mapId, reg, value` | server-only | 1-4 |
| `Hontale0` | `showHontaleSlotBusyMessage` | `self, slot, udc` | server-only | 1-9 |
| `Hontale1` | `cacheScriptFunc` | `self` | server-only | 1-35 |
| `Hontale1` | `getHontaleBossFieldSetByMapId` | `self, mapId` | server-only | 1-11 |
| `Hontale1` | `hontale_boss1` | `self, p, udc` | server-only | 1-11 |
| `Hontale1` | `hontale_boss2` | `self, p, udc` | server-only | 1-12 |
| `Hontale1` | `hontale_BR` | `self, p, udc` | server-only | 1-58 |
| `Hontale_1` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `Hontale_1` | `hontale_Bdoor` | `self, player, udc` | server-only | 1-80 |
| `Hontale_1` | `hontale_Bopen` | `self, player, udc` | server-only | 1-70 |
| `Hontale_1` | `hontale_BtoB1` | `self, player, udc` | server-only | 1-11 |
| `Hontale_1` | `hontale_C` | `self, player, udc` | server-only | 1-23 |
| `Hontale_1` | `hontale_caveOut` | `self, player, udc, portal` | server-only | 1-12 |
| `Hontale_1` | `hontale_clear` | `self, player` | server-only | 1-4 |
| `Hontale_1` | `hontale_clearByMapId` | `self, mapId` | server-only | 1-12 |
| `Hontale_1` | `hontale_enter1` | `self, player, udc` | server-only | 1-106 |
| `Hontale_1` | `hontale_enterToE` | `self, player, udc` | server-only | 1-20 |
| `Hontale_1` | `hontale_keroben` | `self, player, udc` | server-only | 1-25 |
| `Hontale_1` | `hontale_morph` | `self, player, udc` | server-only | 1-6 |
| `Hontale_1` | `hontale_morph2` | `self, player, udc` | server-only | 1-10 |
| `Hontale_1` | `hontale_out` | `self, player, udc` | server-only | 1-96 |
| `Hontale_1` | `hontale_out1` | `self, player, udc` | server-only | 1-14 |
| `ItemManager` | `buildPotentialCache` | `self, itemOption_img` | client | 1-37 |
| `ItemManager` | `checkScrollValid` | `self, scrollId, targetItemId` | client | 1-38 |
| `ItemManager` | `copyIconData` | `self, to, from` | client | 1-24 |
| `ItemManager` | `dumpPotentialInfoStrings` | `self` | client | 1-43 |
| `ItemManager` | `dumpPotentialInfoStringsInRange` | `self, minGrade, maxGrade` | client | 1-48 |
| `ItemManager` | `ensureCashLoaded` | `self` | client | 1-21 |
| `ItemManager` | `ensureConsumeLoaded` | `self` | client | 1-21 |
| `ItemManager` | `ensureEtcLoaded` | `self` | client | 1-20 |
| `ItemManager` | `ensureInstallLoaded` | `self` | client | 1-21 |
| `ItemManager` | `ensurePetLoaded` | `self` | client | 1-21 |
| `ItemManager` | `ensurePotentialLoaded` | `self` | client | 1-11 |
| `ItemManager` | `ensureWeatherBuffIndexLoaded` | `self` | client | 1-22 |
| `ItemManager` | `finishData` | `self, item, info` | client | 1-47 |
| `ItemManager` | `getItemById` | `self, itemId` | client | 1-72 |
| `ItemManager` | `getPetById` | `self, itemId` | client | 1-4 |
| `ItemManager` | `getPetDefaultTemplate` | `self, itemId` | client | 1-13 |
| `ItemManager` | `getPotentialByCubeItemId` | `self, cubeItemId` | client | 1-6 |
| `ItemManager` | `getPotentialOptions` | `self, pId, reqLevel` | client | 1-25 |
| `ItemManager` | `getPotentialStr` | `self, pId, reqLevel` | client | 1-26 |
| `ItemManager` | `getRaiseItemIDByQuestID` | `self, itemID` | client | 1-3 |
| `ItemManager` | `isArrow` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isBlackCrystal` | `self, itemID` | client | 1-3 |
| `ItemManager` | `isBowArrow` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isBullet` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isConsumeOnPickUp` | `self, itemId` | client | 1-6 |
| `ItemManager` | `isCrossbowArrow` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isExpiredDeleteExcludedItem` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isPet` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isRaiseItem` | `self, itemID` | client | 1-3 |
| `ItemManager` | `isThrowingStars` | `self, itemId` | client | 1-3 |
| `ItemManager` | `isWeatherBuff` | `self, itemID` | client | 1-7 |
| `ItemManager` | `loadCashItemData` | `self, itemId, data` | client | 1-59 |
| `ItemManager` | `loadConsumeItemData` | `self, itemId, data` | client | 1-200 |
| `ItemManager` | `loadEtcItemData` | `self, itemId, data` | client | 1-103 |
| `ItemManager` | `loadIcon` | `self, item, info` | client | 1-59 |
| `ItemManager` | `loadInstallItemData` | `self, itemId, data` | client | 1-31 |
| `ItemManager` | `loadItemPart1` | `self` | client | 1-52 |
| `ItemManager` | `loadItemPart2` | `self` | client | 1-65 |
| `ItemManager` | `loadPetData` | `self, itemId, data` | client | 1-144 |
| `ItemManager` | `loadPotentialTables` | `self, itemOption_img, itemOptionCash_img` | client | 1-4 |
| `ItemManager` | `needsIconReload` | `self, item` | client | 1-14 |
| `ItemManager` | `parseActiveEffectItemData` | `self, effectData` | client | 1-52 |
| `ItemManager` | `parsePotential` | `self, itemOption_img` | client | 1-6 |
| `ItemManager` | `parsePotentialCash` | `self, itemOptionCash_img` | client | 1-3 |
| `ItemManager` | `pTest` | `self, itemId, curGrade` | client | 1-94 |
| `ItemManager` | `reloadItemData` | `self, itemId` | client | 1-53 |
| `ItemPotentialOutlineLogic` | `applyPotentialOutline` | `self, slotRoot, equipInfo, isEquip` | client | 1-17 |
| `ItemPotentialOutlineLogic` | `clearPotentialOutline` | `self, slotRoot` | client | 1-12 |
| `ItemPotentialOutlineLogic` | `ensurePotentialOutline` | `self, slotRoot` | client | 1-38 |
| `ItemPotentialOutlineLogic` | `fitPotentialOutlineToSlot` | `self, slotRoot, outline` | client | 1-15 |
| `ItemPotentialOutlineLogic` | `getPotentialOutlineColor` | `self, potential` | client | 1-11 |
| `ItemVariationLogic` | `make` | `self, type, value` | client | 1-55 |
| `ItemVariationLogic` | `makeChaosScroll` | `self, value` | client | 1-30 |
| `ItemVariationLogic` | `variation` | `self, type, eqp` | client | 1-18 |
| `ItemVariationLogic` | `variationChaosScroll` | `self, eqp` | client | 1-18 |
| `Item_1` | `buildStepUpRewardBoxMessage` | `self, rewards` | server-only | 1-16 |
| `Item_1` | `cacheScriptFunc` | `self` | server-only | 1-43 |
| `Item_1` | `canGainStepUpRewardBox` | `self, player, rewards` | server-only | 1-95 |
| `Item_1` | `consume_2022428` | `self, player, udc` | server-only | 1-29 |
| `Item_1` | `consume_2430066` | `self, player, udc` | server-only | 1-4 |
| `Item_1` | `consume_2430067` | `self, player, udc` | server-only | 1-4 |
| `Item_1` | `consume_2430068` | `self, player, udc` | server-only | 1-4 |
| `Item_1` | `consume_2430069` | `self, player, udc` | server-only | 1-4 |
| `Item_1` | `consume_2430070` | `self, player, udc` | server-only | 1-4 |
| `Item_1` | `consume_2434568` | `self, player, udc` | server-only | 1-21 |
| `Item_1` | `consumeStepUpRewardBox` | `self, player, udc, boxItemId` | server-only | 1-32 |
| `Item_1` | `createStepUpRewardItemInfo` | `self, itemId, itemFlag, expTime` | server-only | 1-28 |
| `Item_1` | `gainStepUpRewardBox` | `self, player, rewards, sourceItemId` | server-only | 1-24 |
| `Item_1` | `getStepUpRewardBoxInfo` | `self, boxItemId` | server-only | 1-63 |
| `Item_1` | `getStepUpRewardExpireTime` | `self` | server-only | 1-5 |
| `Item_1` | `inventorySlotExpand` | `self, player, udc` | server-only | 1-27 |
| `Item_1` | `killarmush` | `self, player, udc, portal` | server-only | 1-43 |
| `Item_1` | `removethorns` | `self, player, udc` | server-only | 1-9 |
| `Jipangu` | `cacheScriptFunc` | `self` | server-only | 1-37 |
| `Jipangu` | `con1` | `self, p, udc` | server-only | 1-5 |
| `Jipangu` | `con2` | `self, p, udc` | server-only | 1-5 |
| `Jipangu` | `con3` | `self, p, udc` | server-only | 1-12 |
| `Jipangu` | `con4` | `self, p, udc` | server-only | 1-3 |
| `Jipangu` | `getTheBossPartyUsers` | `self, p` | server-only | 1-29 |
| `Jipangu` | `getTheBossWeeklyLimitedMemberNames` | `self, users` | server-only | 1-3 |
| `Jipangu` | `hasTheBossEntranceItem` | `self, p` | server-only | 1-3 |
| `Jipangu` | `inSauna` | `self, p, udc` | server-only | 1-16 |
| `Jipangu` | `naomi1` | `self, p, udc` | server-only | 1-109 |
| `Jipangu` | `s_dungeon` | `self, p, udc` | server-only | 1-79 |
| `Jipangu` | `warp_ninjaCastle` | `self, p, udc` | server-only | 1-17 |
| `JobLogic` | `isAran` | `self, job` | client | 1-6 |
| `JobLogic` | `isBeginner` | `self, job` | client | 1-6 |
| `JobLogic` | `isDual` | `self, job, subcategory` | client | 1-11 |
| `JobLogic` | `isEvan` | `self, job` | client | 1-6 |
| `Job_4th` | `cacheScriptFunc` | `self` | server-only | 1-35 |
| `Job_4th` | `s4berserk` | `self, player, udc` | server-only | 1-28 |
| `Job_4th` | `s4berserk_move` | `self, player, udc` | server-only | 1-12 |
| `Job_4th` | `s4blocking` | `self, player, udc` | server-only | 1-37 |
| `Job_4th` | `s4blocking_enter` | `self, player, udc` | server-only | 1-9 |
| `Job_4th` | `s4common1_clear` | `self, player, udc` | server-only | 1-10 |
| `Job_4th` | `s4common1_out` | `self, player, udc` | server-only | 1-21 |
| `Job_4th` | `s4common2` | `self, player, udc` | server-only | 1-66 |
| `Job_4th` | `s4efreet` | `self, player, udc` | server-only | 1-53 |
| `Job_4th` | `s4firehawk` | `self, player, udc` | server-only | 1-31 |
| `Job_4th` | `s4freeze_item` | `self, player, udc` | server-only | 1-24 |
| `Job_4th` | `s4hitman` | `self, player, udc` | server-only | 1-23 |
| `Job_4th` | `s4holycharge` | `self, player, udc` | server-only | 1-20 |
| `Job_4th` | `s4iceeagle` | `self, player, udc` | server-only | 1-30 |
| `Job_4th` | `s4mind` | `self, player, udc` | server-only | 1-40 |
| `Job_4th` | `s4mind_end` | `self, player, udc` | server-only | 1-10 |
| `Job_4th` | `s4mind_in` | `self, player, udc` | server-only | 1-33 |
| `Job_4th` | `s4mind_out` | `self, player, udc` | server-only | 1-9 |
| `Job_4th` | `s4nest` | `self, player, udc` | server-only | 1-27 |
| `Job_4th` | `s4resur_enter` | `self, player, udc` | server-only | 1-18 |
| `Job_4th` | `s4resur_out` | `self, player, udc` | server-only | 1-12 |
| `Job_4th` | `s4resurrection` | `self, player, udc` | server-only | 1-18 |
| `Job_4th` | `s4rush` | `self, player, udc` | server-only | 1-53 |
| `Job_4th` | `s4ship_out` | `self, player, udc` | server-only | 1-17 |
| `Job_4th` | `s4snipe` | `self, player, udc` | server-only | 1-53 |
| `Job_4th` | `s4strike` | `self, player, udc` | server-only | 1-74 |
| `Job_4th` | `s4strike_statue` | `self, player, udc` | server-only | 1-114 |
| `Job_4th` | `s4super_out` | `self, player, udc` | server-only | 1-17 |
| `Job_4th` | `s4time` | `self, player, udc` | server-only | 1-22 |
| `Job_4th` | `s4tornado` | `self, player, udc` | server-only | 1-24 |
| `Job_4th` | `s4tornado_enter` | `self, player, udc` | server-only | 1-10 |
| `JsonUtils` | `getJSONEscapeMap` | `self` | client | 1-29 |
| `JsonUtils` | `parseJSON` | `self, str, decodeUnicode` | client | 1-203 |
| `JsonUtils` | `tableToJSON` | `self, value` | client | 1-115 |
| `KeyConfigActionType` | `getKeyTypeName` | `self, keyType` | client | 1-51 |
| `KeyConfigUILogic` | `HandleEntityEnabledInHierarchyChangedEvent` | `self, event` | client | 1-38 |
| `LoginLogic` | `addCharacterList` | `self, playerInfo, equipment` | client | 1-59 |
| `LoginLogic` | `applyLoadingMapZoom` | `self, cameraPos` | client | 1-12 |
| `LoginLogic` | `changeCharInfosPage` | `self, category, direction` | client | 1-63 |
| `LoginLogic` | `checkgetCharacterList` | `self, senderUserId` | server-only | 1-133 |
| `LoginLogic` | `checkName` | `self, name, senderUserId` | server-only | 1-47 |
| `LoginLogic` | `checkNameResponseToClient` | `self, response` | client | 1-20 |
| `LoginLogic` | `clear` | `self` | client | 1-7 |
| `LoginLogic` | `clearCachedPlayerInfoList` | `self, userId` | server-only | 1-6 |
| `LoginLogic` | `clearCachedPlayerListResponse` | `self, userId` | server-only | 1-7 |
| `LoginLogic` | `clearCharacterSlot` | `self, slotIndex` | client | 1-14 |
| `LoginLogic` | `clearDelayedAccountInfoWorldRender` | `self, key` | client | 1-7 |
| `LoginLogic` | `clickBtPage` | `self, direction` | client | 1-8 |
| `LoginLogic` | `connectCreateCharacterButtons` | `self, rootPath` | client | 1-21 |
| `LoginLogic` | `createNameTag` | `self, chrEntity, name` | client | 1-34 |
| `LoginLogic` | `createPlayer` | `self, userId, name, class, gender, info` | server-only | 1-119 |
| `LoginLogic` | `deletePlayer` | `self, playerId, senderUserId` | server-only | 1-71 |
| `LoginLogic` | `deletePlayerToClient` | `self, index` | client | 1-116 |
| `LoginLogic` | `doCreateCharacter` | `self, name, class, gender, info, senderUserId` | server-only | 1-79 |
| `LoginLogic` | `doCreateCharacterResponseToClient` | `self, success` | client | 1-8 |
| `LoginLogic` | `drawAccountInfo` | `self` | client | 1-20 |
| `LoginLogic` | `failedDeletePlayerToClient` | `self, reason` | client | 1-9 |
| `LoginLogic` | `failedGetCharacterListToClient` | `self` | client | 1-4 |
| `LoginLogic` | `failedGetCharacterListToClientBan` | `self, type, reason, date, banCode` | client | 1-15 |
| `LoginLogic` | `failedGetCharacterListToClientStatus` | `self, reason` | client | 1-4 |
| `LoginLogic` | `failedLogin` | `self, type, nugu` | client | 1-20 |
| `LoginLogic` | `get` | `self, name` | client | 1-3 |
| `LoginLogic` | `getCachedPlayerInfo` | `self, userId, playerId` | server-only | 1-11 |
| `LoginLogic` | `getCachedPlayerListResponse` | `self, userId` | server-only | 1-6 |
| `LoginLogic` | `getCharacterList` | `self, userId` | server-only | 1-77 |
| `LoginLogic` | `getMakeCharInfoTbl` | `self, key` | client | 1-3 |
| `LoginLogic` | `initCharInfo` | `self, class, gender` | client | 1-78 |
| `LoginLogic` | `initLogin` | `self, nickname, profileCode, returnToTitle` | client | 1-151 |
| `LoginLogic` | `isDeletingPlayer` | `self, userId` | server-only | 1-7 |
| `LoginLogic` | `isLoginAuthorizedUser` | `self, userId` | server-only | 1-13 |
| `LoginLogic` | `moveCamera` | `self, pos, playSound, fadeInCallback` | client | 1-30 |
| `LoginLogic` | `moveSelectPlayer` | `self, direction` | client | 1-42 |
| `LoginLogic` | `OnBeginPlay` | `self` | server-only | 1-6 |
| `LoginLogic` | `onBtAran` | `self` | client | 1-18 |
| `LoginLogic` | `onBtDelete` | `self` | client | 1-44 |
| `LoginLogic` | `onBtKnight` | `self` | client | 1-18 |
| `LoginLogic` | `onBtNew` | `self` | client | 1-11 |
| `LoginLogic` | `onBtNormal` | `self` | client | 1-18 |
| `LoginLogic` | `onBtSelect` | `self` | client | 1-44 |
| `LoginLogic` | `onCharName_BtNo` | `self` | client | 1-3 |
| `LoginLogic` | `onCharName_BtYes` | `self` | client | 1-19 |
| `LoginLogic` | `onCharSet_BtNo` | `self` | client | 1-5 |
| `LoginLogic` | `onCharSet_BtYes` | `self` | client | 1-23 |
| `LoginLogic` | `onDestroy` | `self, senderUserId` | server-only | 1-4 |
| `LoginLogic` | `onDestroyBtn` | `self` | client | 1-3 |
| `LoginLogic` | `onLoginBtn` | `self` | client | 1-34 |
| `LoginLogic` | `removeCachedPlayerInfo` | `self, userId, playerId` | server-only | 1-11 |
| `LoginLogic` | `renderAccountInfoWithWorldText` | `self, entity, yPos` | client | 1-35 |
| `LoginLogic` | `renderCharacterPage` | `self` | client | 1-136 |
| `LoginLogic` | `requestDelayedAccountInfoWorldRender` | `self, key, yPos` | client | 1-20 |
| `LoginLogic` | `setCachedPlayerInfoList` | `self, userId, playerInfoList` | server-only | 1-26 |
| `LoginLogic` | `setCachedPlayerInfoResponse` | `self, userId, playerId, response` | server-only | 1-20 |
| `LoginLogic` | `setCachedPlayerListResponse` | `self, userId, response` | server-only | 1-6 |
| `LoginLogic` | `setCharacterActionButtonsEnabled` | `self, enable` | client | 1-16 |
| `LoginLogic` | `setCharacterList` | `self, playerInfoList, equipmentList` | client | 1-34 |
| `LoginLogic` | `setCreateCharacterEntities` | `self, rootPath` | client | 1-34 |
| `LoginLogic` | `setDeletingPlayer` | `self, userId, deleting` | server-only | 1-11 |
| `LoginLogic` | `setEquip` | `self, chrEntityIndex, slot, equip, equipCacheIndex` | client | 1-87 |
| `LoginLogic` | `setLoginAuthorizedUser` | `self, userId, authorized` | server-only | 1-11 |
| `LoginLogic` | `setLoginButtonEnabled` | `self, enable` | client | 1-6 |
| `LoginLogic` | `setVersionGlyphPosX` | `self` | client | 1-14 |
| `MTS` | `getFlag` | `self, index` | client | 1-3 |
| `MTS` | `getIndexFromFlag` | `self, value` | client | 1-10 |
| `MTS` | `isBuff` | `self, skillID, index` | client | 1-14 |
| `MacroQuestionLogic` | `askTextNoEsc` | `self, udc, text, default` | server-only | 1-10 |
| `MacroQuestionLogic` | `buildAttackPowerText` | `self, target` | server-only | 1-14 |
| `MacroQuestionLogic` | `buildReport` | `self, target, question, answer` | server-only | 1-8 |
| `MacroQuestionLogic` | `buildStatText` | `self, target` | server-only | 1-22 |
| `MacroQuestionLogic` | `captureTimeoutAnswerClient` | `self, requestId` | client | 1-27 |
| `MacroQuestionLogic` | `clearQuestionClock` | `self, userId` | server-only | 1-10 |
| `MacroQuestionLogic` | `completeQuestion` | `self, requestId, adminUserId, userId, targetName, question, answer` | server-only | 1-27 |
| `MacroQuestionLogic` | `createQuestionRequest` | `self, adminUserId, userId, targetName, timeoutSeconds, requestKey, question, fromWeb` | server-only | 1-24 |
| `MacroQuestionLogic` | `createRequestKey` | `self, userId` | server-only | 1-7 |
| `MacroQuestionLogic` | `finalizeTimeoutQuestion` | `self, requestId` | server-only | 1-30 |
| `MacroQuestionLogic` | `findUserByAccountIdOrName` | `self, accountId, targetName` | server-only | 1-17 |
| `MacroQuestionLogic` | `findUserByName` | `self, targetName` | server-only | 1-9 |
| `MacroQuestionLogic` | `getActivityQuestionBlockReason` | `self, target` | server-only | 1-20 |
| `MacroQuestionLogic` | `getQuestionNpcTemplateId` | `self` | server-only | 1-4 |
| `MacroQuestionLogic` | `getQuestionRequest` | `self, requestId` | server-only | 1-7 |
| `MacroQuestionLogic` | `getQuestionText` | `self, questionType, customQuestion` | server-only | 1-23 |
| `MacroQuestionLogic` | `getQuestionTimeoutSeconds` | `self, questionType` | server-only | 1-7 |
| `MacroQuestionLogic` | `getServerKnownInputText` | `self, userId` | server-only | 1-11 |
| `MacroQuestionLogic` | `popQuestionRequest` | `self, requestId` | server-only | 1-17 |
| `MacroQuestionLogic` | `readDialogInputText` | `self, udc` | server-only | 1-7 |
| `MacroQuestionLogic` | `requestJail` | `self, targetName, inJail, senderUserId` | server-only | 1-48 |
| `MacroQuestionLogic` | `requestQuestion` | `self, targetName, questionType, customQuestion, senderUserId` | server-only | 1-60 |
| `MacroQuestionLogic` | `requestQuestionFromWeb` | `self, requestKey, targetAccountId, targetName, questionType, customQuestion` | server-only | 1-53 |
| `MacroQuestionLogic` | `sayToOperator` | `self, adminUser, message` | server-only | 1-18 |
| `MacroQuestionLogic` | `sendQuestionResultToWeb` | `self, requestKey, forUserId, targetName, question, answer, status, reason` | server-only | 1-22 |
| `MacroQuestionLogic` | `startQuestionClock` | `self, target, timeoutSeconds` | server-only | 1-7 |
| `MacroQuestionLogic` | `submitTimeoutAnswer` | `self, requestId, answer, senderUserId` | server-only | 1-15 |
| `MacroQuestionLogic` | `timeoutQuestion` | `self, requestId` | server-only | 1-16 |
| `MacroQuestionLogic` | `trim` | `self, text` | server-only | 1-7 |
| `MagnifierLogic` | `clear` | `self` | client | 1-14 |
| `MagnifierLogic` | `set` | `self, itemId, useSlot` | client | 1-37 |
| `MagnifierLogic` | `showEffect` | `self, slot` | client | 1-9 |
| `Make` | `buildNpcCraftMaterials` | `self, materialList, multiplier, mesoCost` | server-only | 1-25 |
| `Make` | `buildNpcCraftMaterialsFromArrays` | `self, itemList, quantityList, multiplier, mesoCost` | server-only | 1-23 |
| `Make` | `cacheScriptFunc` | `self` | server-only | 1-31 |
| `Make` | `carlie` | `self, player, udc` | server-only | 1-374 |
| `Make` | `logNpcCraftItem` | `self, player, itemID, quantity, resultEquipInfo, materials` | server-only | 1-12 |
| `Make` | `make_ariant1` | `self, player, udc` | server-only | 1-160 |
| `Make` | `make_elnath` | `self, player, udc` | server-only | 1-224 |
| `Make` | `make_ludi1` | `self, player, udc` | server-only | 1-253 |
| `Make` | `make_ludi2` | `self, player, udc` | server-only | 1-288 |
| `Make` | `make_ludi3` | `self, player, udc` | server-only | 1-331 |
| `Make` | `make_ludi4` | `self, player, udc` | server-only | 1-663 |
| `Make` | `make_murueng` | `self, player, udc` | server-only | 1-154 |
| `Make` | `make_orbis` | `self, player, udc` | server-only | 1-176 |
| `Make` | `minar_weapon` | `self, player, udc` | server-only | 1-303 |
| `Make` | `owen` | `self, player, udc` | server-only | 1-88 |
| `Make` | `refine_ellinia` | `self, player, udc` | server-only | 1-220 |
| `Make` | `refine_elnath` | `self, player, udc` | server-only | 1-309 |
| `Make` | `refine_henesys` | `self, player, udc` | server-only | 1-450 |
| `Make` | `refine_kerning` | `self, player, udc` | server-only | 1-421 |
| `Make` | `refine_kerning2` | `self, player, udc` | server-only | 1-268 |
| `Make` | `refine_nautillus` | `self, player, udc` | server-only | 1-161 |
| `Make` | `refine_perion` | `self, player, udc` | server-only | 1-300 |
| `Make` | `refine_perion2` | `self, player, udc` | server-only | 1-269 |
| `Make` | `refine_sleepy` | `self, player, udc` | server-only | 1-403 |
| `MapManager` | `activeField` | `self, field` | server-only | 1-49 |
| `MapManager` | `deactiveField` | `self, field` | server-only | 1-48 |
| `MapManager` | `finalizeLoadMap` | `self` | client | 1-10 |
| `MapManager` | `getAreaCode` | `self, mapID` | client | 1-4 |
| `MapManager` | `getField` | `self, mapId` | client | 1-10 |
| `MapManager` | `getMap` | `self, mapId` | client | 1-9 |
| `MapManager` | `getMapHelperAnim` | `self, path` | client | 1-27 |
| `MapManager` | `getObejct` | `self, path` | client | 1-27 |
| `MapManager` | `getObjectAnim` | `self, path` | client | 1-27 |
| `MapManager` | `initLoadMap` | `self` | client | 1-6 |
| `MapManager` | `isConnected` | `self, dwFrom, dwTo` | client | 1-19 |
| `MapManager` | `isDojoField` | `self, mapId` | client | 1-4 |
| `MapManager` | `isDojoPracticeField` | `self, mapId` | client | 1-5 |
| `MapManager` | `isForbidFallDown` | `self, map, FHID` | client | 1-5 |
| `MapManager` | `isLetterBoxExcludedMap` | `self, mapID` | client | 1-3 |
| `MapManager` | `isNeedSkillForFlyMap` | `self, mapID` | client | 1-4 |
| `MapManager` | `loadBack` | `self, data` | client | 1-26 |
| `MapManager` | `loadFHOption` | `self` | client | 1-25 |
| `MapManager` | `loadMap` | `self` | client | 1-10 |
| `MapManager` | `loadMapBackStage` | `self` | client | 1-34 |
| `MapManager` | `loadMAPDIR` | `self` | client | 1-37 |
| `MapManager` | `loadMapFHOptionStage` | `self` | client | 1-5 |
| `MapManager` | `loadMapObjStage` | `self, objKey` | client | 1-41 |
| `MapManager` | `loadMapServerAreaCodeStage` | `self` | server-only | 1-6 |
| `MapManager` | `loadMapServerMAPDIRStage` | `self` | server-only | 1-6 |
| `MapManager` | `loadMapType` | `self` | server-only | 1-16 |
| `MapManager` | `loadMapWorldStage` | `self` | client | 1-21 |
| `MapManager` | `loadMapZMassStage` | `self` | client | 1-5 |
| `MapManager` | `loadWorldMap` | `self, t` | client | 1-95 |
| `MapManager` | `loadZMass` | `self` | client | 1-25 |
| `MapManager` | `OnEndPlay` | `self` | server-only | 1-4 |
| `MapManager` | `setAreaCode` | `self` | client | 1-29 |
| `MapManager` | `setLetterBoxExcludedMap` | `self` | client | 1-8 |
| `MapManager` | `setNeedSkillForFlyMap` | `self` | client | 1-20 |
| `MapManager` | `updateField` | `self` | server-only | 1-89 |
| `MapManager` | `updateMobGen` | `self` | server-only | 1-23 |
| `MapUtilLogic` | `findClosestObjectTile` | `self, worldPos, mapName` | client | 1-41 |
| `MapUtilLogic` | `getDropPoiont` | `self, worldPos, dir` | client | 1-41 |
| `MapUtilLogic` | `getFootholdTile` | `self, worldPos, mapName` | client | 1-64 |
| `MapUtilLogic` | `getFormattedMapPath` | `self, mapID` | client | 1-4 |
| `MapUtilLogic` | `getLadderEntity` | `self, worldPos, width, height, mapName` | client | 1-105 |
| `MapUtilLogic` | `getPlayerCount` | `self, mapEntity` | client | 1-13 |
| `MapUtils` | `calculateLandingPosition` | `self, map, dropPos, jumpHeight` | client | 1-38 |
| `MapUtils` | `getFullNameById` | `self, mapId` | client | 1-10 |
| `MapUtils` | `getMapIdByName` | `self, mapName` | client | 1-4 |
| `MapUtils` | `getMapNameById` | `self, mapId` | client | 1-9 |
| `MapUtils` | `getStreetNameById` | `self, mapId` | client | 1-9 |
| `MasteryLogic` | `canUseSkill` | `self, jobCode, skillId` | client | 1-3 |
| `MasteryLogic` | `getIncEvadeSkill` | `self, player` | client | 1-29 |
| `MasteryLogic` | `getMastery` | `self, player, weaponType, attackType` | client | 1-161 |
| `MasteryLogic` | `getMasteryBySkill` | `self, player, skillID` | client | 1-10 |
| `MasteryLogic` | `jobCodeToGroup` | `self, jobCode` | client | 1-3 |
| `MasteryLogic` | `skillIdToGroup` | `self, skillId` | client | 1-4 |
| `MathUtils` | `alwaysCeil` | `self, num` | client | 1-7 |
| `MathUtils` | `alwaysFloor` | `self, num` | client | 1-7 |
| `MathUtils` | `decompose_digit` | `self, n` | client | 1-23 |
| `MathUtils` | `format_integer_to_korean` | `self, n` | client | 1-31 |
| `MathUtils` | `format_thousands_for` | `self, n` | client | 1-23 |
| `MathUtils` | `round` | `self, num` | client | 1-7 |
| `MathUtils` | `roundToEvenOffset` | `self, offset` | client | 1-14 |
| `MathUtils` | `truncate` | `self, num` | client | 1-3 |
| `MessageLogic` | `OnBeginPlay` | `self` | client | 1-4 |
| `MessageLogic` | `onDropPickUpMessage` | `self, type, idOrMesoAmount, amount` | client | 1-42 |
| `MessageLogic` | `onIncEXPMessage` | `self, t` | client | 1-37 |
| `MobActionPartType` | `typeToString` | `self, type` | client | 1-42 |
| `MobAttackElemAttr` | `getElemAttr` | `self, elemAttr` | client | 1-3 |
| `MobAttackElemAttr` | `OnBeginPlay` | `self` | client | 1-8 |
| `MobAttackLogic` | `doMobSkill` | `self, mob, skillId, skillLevel, delay` | server-only | 1-36 |
| `MobAttackLogic` | `doMobSkill_statChange` | `self, mob, skillID, skillLevel, msld, delay` | server-only | 1-89 |
| `MobAttackLogic` | `doMobSkill_summon` | `self, mob, skillID, skillLevel, msld, delay` | server-only | 1-39 |
| `MobAttackLogic` | `doMobSkill_userStatChange` | `self, mob, skillID, skillLevel, msld, delay` | server-only | 1-57 |
| `MobAttackLogic` | `findDamagedByMobInRect` | `self, box` | client | 1-25 |
| `MobAttackLogic` | `findHitSummonedInRect` | `self, box, out, maxCount` | client | 1-19 |
| `MobAttackLogic` | `findTargetByLtRb` | `self, mob, lt, rb, pos, faceLeft, triggerGroupName` | client | 1-29 |
| `MobAttackLogic` | `isDazzledMobByMe` | `self, mob` | client | 1-5 |
| `MobAttackLogic` | `letMobChasePuppet` | `self, puppet, chase` | client | 1-27 |
| `MobAttackLogic` | `processAttack` | `self, mob, attackIdx, dwData` | client | 1-246 |
| `MobAttackLogic` | `setBallDestPoint` | `self, start, hit, left, rangeLen` | client | 1-45 |
| `MobAttackLogic` | `showHeal` | `self, mob, delta` | client | 1-13 |
| `MobAttackLogic` | `tryDoingAttack` | `self, mob, targetType, checkRangeOnly` | client | 1-337 |
| `MobAttackLogic` | `tryDoingSkill` | `self, mob` | client | 1-65 |
| `MobAttackLogic` | `tryFirstAttack` | `self, mob` | client | 1-61 |
| `MobFlyLogic` | `updateMovePath` | `self, mob` | client | 1-296 |
| `MobKnockbackLogic` | `clampKnockbackMapEdge` | `self, mob` | client | 1-48 |
| `MobKnockbackLogic` | `updateFlyKnockbackPath` | `self, mob, hitByLeft, knockbackType, senderUid, mobPosSnapshot` | client | 1-88 |
| `MobKnockbackLogic` | `updateKnockbackPath` | `self, mob, hitByLeft, knockbackType, delay, forceEndPos, baseDistance, knockbackMoveScale, knockbackWalkSpeedScale, knockbackWalkDragScale, id, senderUid, mobPosSnapshot` | client | 1-101 |
| `MobLeveltagLogic` | `createNametag` | `self, type, parentEntity, name, nametagRUID, offset, textColor` | client | 1-72 |
| `MobLeveltagLogic` | `drawNametag` | `self, type, parentEntity, name, subName, nametagRUID, position, textColor` | client | 1-42 |
| `MobLeveltagLogic` | `getLeveltagEntity` | `self, type, targetEntity` | client | 1-10 |
| `MobLeveltagLogic` | `removeNametag` | `self, type, parentEntity` | client | 1-13 |
| `MobManager` | `getMobAttackInfo` | `self, mobID, attackIdx` | client | 1-9 |
| `MobManager` | `getMobSkillInfo` | `self, mobId, idx` | client | 1-6 |
| `MobManager` | `getMobSkills` | `self, mobId` | client | 1-7 |
| `MobManager` | `getMonster` | `self, mobId` | client | 1-6 |
| `MobManager` | `getMonsterEntry` | `self, mobId, key` | client | 1-8 |
| `MobManager` | `getTotalDelayAction` | `self, mobID, key` | client | 1-16 |
| `MobManager` | `loadMob` | `self, mobId` | client | 1-113 |
| `MobManager` | `OnBeginPlay` | `self` | client | 1-5 |
| `MobManager` | `parseInfo` | `self, mobId, info` | client | 1-121 |
| `MobManager` | `parseMobElementAttr` | `self, elemAttr` | client | 1-20 |
| `MobWalkLogic` | `updateMovePath` | `self, mob` | client | 1-74 |
| `MobWalkLogic` | `updateMovePathStop` | `self, mob` | client | 1-69 |
| `MobileActionSlotLogic` | `alignCooldownNumberToIconCenter` | `self, slotKey, slotEntity, remainSec` | client | 1-40 |
| `MobileActionSlotLogic` | `ApplyMobileActionSlotLayout` | `self, openX, openY, hiddenOffsetX` | client | 1-24 |
| `MobileActionSlotLogic` | `applyMobileActionSlotOpacity` | `self` | client | 1-26 |
| `MobileActionSlotLogic` | `applyMobileActionSlotSettingBoxState` | `self` | client | 1-11 |
| `MobileActionSlotLogic` | `applySlotVisual` | `self, slotKey` | client | 1-105 |
| `MobileActionSlotLogic` | `arrangeMobileActionSlotLayerForUtilDlg` | `self` | client | 1-41 |
| `MobileActionSlotLogic` | `canExecuteMobileJumpAction` | `self, player` | client | 1-12 |
| `MobileActionSlotLogic` | `clearAllVisibleItemCountVisuals` | `self` | client | 1-17 |
| `MobileActionSlotLogic` | `clearCooldownVisual` | `self, slotKey` | client | 1-24 |
| `MobileActionSlotLogic` | `clearItemCountVisual` | `self, slotKey` | client | 1-9 |
| `MobileActionSlotLogic` | `clearVisibleItemCountVisual` | `self, itemId` | client | 1-18 |
| `MobileActionSlotLogic` | `createDefaultMobileActionSlotConfig` | `self` | server-only | 1-12 |
| `MobileActionSlotLogic` | `decodeSlotConfig` | `self, dataTable` | client | 1-39 |
| `MobileActionSlotLogic` | `ensureCooldownGauge` | `self, slotKey` | client | 1-42 |
| `MobileActionSlotLogic` | `ensureIconEntity` | `self, slotKey` | client | 1-47 |
| `MobileActionSlotLogic` | `ensureKeySetConfig` | `self, keySetConfigs, keySet` | client | 1-7 |
| `MobileActionSlotLogic` | `ensureSlotNumberComponent` | `self, targetEntity` | client | 1-11 |
| `MobileActionSlotLogic` | `executeMobileActionSlotHold` | `self, slotType, id` | client | 1-10 |
| `MobileActionSlotLogic` | `executeMobileActionSlotPress` | `self, slotType, id` | client | 1-10 |
| `MobileActionSlotLogic` | `executeMobileAttackHoldAction` | `self, player` | client | 1-7 |
| `MobileActionSlotLogic` | `executeMobileAttackPressAction` | `self, player` | client | 1-13 |
| `MobileActionSlotLogic` | `executeMobileJumpHoldAction` | `self, player` | client | 1-24 |
| `MobileActionSlotLogic` | `executeMobileJumpPressAction` | `self, player` | client | 1-24 |
| `MobileActionSlotLogic` | `executeSlotEntry` | `self, slotType, id` | client | 1-60 |
| `MobileActionSlotLogic` | `finishMobileActionSlotOpacityInput` | `self` | client | 1-10 |
| `MobileActionSlotLogic` | `getAspectFitSlotIconSize` | `self, slotKey, sourceSize` | client | 1-11 |
| `MobileActionSlotLogic` | `getCooldownNumberScale` | `self, slotKey` | client | 1-11 |
| `MobileActionSlotLogic` | `getDraggedSkillId` | `self, clickedEntity` | client | 1-11 |
| `MobileActionSlotLogic` | `getDraggedUIElementType` | `self, clickedEntity` | client | 1-12 |
| `MobileActionSlotLogic` | `getEmptySpriteTemplate` | `self` | client | 1-18 |
| `MobileActionSlotLogic` | `getMobileActionSlotOpacityHalfRange` | `self` | client | 1-9 |
| `MobileActionSlotLogic` | `getMobileActiveKeydownSkillID` | `self, player` | client | 1-26 |
| `MobileActionSlotLogic` | `getSkillCooldownSec` | `self, skillId` | client | 1-32 |
| `MobileActionSlotLogic` | `getSlotIconMaxSize` | `self, slotKey` | client | 1-15 |
| `MobileActionSlotLogic` | `getSlotNames` | `self` | client | 1-19 |
| `MobileActionSlotLogic` | `HandleMobileActionSlotEnableUIEvent` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `handleMobileActionSlotHoldTimer` | `self` | client | 1-37 |
| `MobileActionSlotLogic` | `HandleMobileActionSlotKeyConfigAllRemoveCountEvent` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `HandleMobileActionSlotKeyConfigRemoveCountEvent` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `HandleMobileActionSlotKeyConfigUpdateCountEvent` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `HandleMobileActionSlotOpacityMouseMoveEvent` | `self, event` | client | 1-10 |
| `MobileActionSlotLogic` | `Initialize` | `self, user, playerId, preloadData` | server-only | 1-48 |
| `MobileActionSlotLogic` | `initializeMobileActionSlotsClient` | `self, showIfMobile` | client | 1-26 |
| `MobileActionSlotLogic` | `isLocalPlayerInitializedClient` | `self` | client | 1-4 |
| `MobileActionSlotLogic` | `isMobileActionSlotKey` | `self, slotKey` | client | 1-9 |
| `MobileActionSlotLogic` | `isMobileActionSlotRepeatEntry` | `self, slotType, id` | client | 1-9 |
| `MobileActionSlotLogic` | `IsMobileActionSlotSettingBoxOpen` | `self` | client | 1-3 |
| `MobileActionSlotLogic` | `isMobileActionSlotUIActive` | `self` | client | 1-4 |
| `MobileActionSlotLogic` | `isSlotEntryAllowed` | `self, slotType, id` | client | 1-9 |
| `MobileActionSlotLogic` | `normalizeKeySet` | `self, keySet` | client | 1-7 |
| `MobileActionSlotLogic` | `normalizeMobileActionSlotOpacityPercent` | `self, value` | client | 1-11 |
| `MobileActionSlotLogic` | `OnBeginPlay` | `self` | client | 1-16 |
| `MobileActionSlotLogic` | `onKeySwapButtonClick` | `self` | client | 1-10 |
| `MobileActionSlotLogic` | `onKeySwapTouchDown` | `self` | client | 1-6 |
| `MobileActionSlotLogic` | `onKeySwapTouchUp` | `self` | client | 1-6 |
| `MobileActionSlotLogic` | `onMobileActionSlotOpacityKeyStateChanged` | `self, event` | client | 1-10 |
| `MobileActionSlotLogic` | `onMobileActionSlotOpacityTouchDown` | `self, event` | client | 1-9 |
| `MobileActionSlotLogic` | `onMobileActionSlotOpacityTouchDrag` | `self, event` | client | 1-10 |
| `MobileActionSlotLogic` | `onMobileActionSlotOpacityTouchEndDrag` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `onMobileActionSlotOpacityTouchUp` | `self, event` | client | 1-7 |
| `MobileActionSlotLogic` | `onMobileActionSlotPressed` | `self, slotKey` | client | 1-48 |
| `MobileActionSlotLogic` | `onMobileActionSlotReleased` | `self, slotKey` | client | 1-24 |
| `MobileActionSlotLogic` | `onMobileActionSlotSettingButtonClick` | `self, event` | client | 1-17 |
| `MobileActionSlotLogic` | `onMobileActionSlotToggleButtonClick` | `self` | client | 1-8 |
| `MobileActionSlotLogic` | `onSlotButtonClick` | `self, slotKey` | client | 1-5 |
| `MobileActionSlotLogic` | `OnUpdate` | `self, delta` | client | 1-24 |
| `MobileActionSlotLogic` | `prepareKeySwapClient` | `self` | client | 1-29 |
| `MobileActionSlotLogic` | `prepareMobileActionSlotOpacityControlsClient` | `self` | client | 1-25 |
| `MobileActionSlotLogic` | `prepareMobileActionSlotsClient` | `self` | client | 1-52 |
| `MobileActionSlotLogic` | `prepareMobileActionSlotSettingClient` | `self` | client | 1-38 |
| `MobileActionSlotLogic` | `prepareMobileActionSlotToggleClient` | `self` | client | 1-22 |
| `MobileActionSlotLogic` | `refreshAllSlotVisuals` | `self` | client | 1-7 |
| `MobileActionSlotLogic` | `refreshVisibleItemCountVisual` | `self, itemId, quantity` | client | 1-23 |
| `MobileActionSlotLogic` | `registerDraggedItemToSlot` | `self, slotKey, clickedEntity` | client | 1-48 |
| `MobileActionSlotLogic` | `registerDraggedKeyConfigToSlot` | `self, slotKey` | client | 1-20 |
| `MobileActionSlotLogic` | `registerDraggedMobileKeyConfigPaletteToSlot` | `self, slotKey, clickedEntity` | client | 1-24 |
| `MobileActionSlotLogic` | `registerDraggedSkillToSlot` | `self, slotKey, clickedEntity` | client | 1-11 |
| `MobileActionSlotLogic` | `releaseMobileKeydownSkill` | `self, player, skillID` | client | 1-14 |
| `MobileActionSlotLogic` | `removeSameEntryFromOtherSlots` | `self, slotConfig, targetSlotKey, slotType, id` | client | 1-17 |
| `MobileActionSlotLogic` | `removeSlotNumberComponent` | `self, targetEntity` | client | 1-16 |
| `MobileActionSlotLogic` | `resetClientSlotStateForCharacterLoad` | `self` | client | 1-16 |
| `MobileActionSlotLogic` | `resetMobileActionSlotToggleStateForCharacterLoad` | `self` | client | 1-17 |
| `MobileActionSlotLogic` | `resolveCooldownLookupId` | `self, skillId` | client | 1-17 |
| `MobileActionSlotLogic` | `resolveCooldownTotalSec` | `self, slotKey, skillId, coolEnd, remain, dataTotal` | client | 1-25 |
| `MobileActionSlotLogic` | `Serialize` | `self, user` | server-only | 1-46 |
| `MobileActionSlotLogic` | `setMobileActionSlotOpacityClient` | `self, value, markDirty` | client | 1-14 |
| `MobileActionSlotLogic` | `setMobileActionSlotOpacityToServer` | `self, opacityPercent, senderUserId` | server-only | 1-15 |
| `MobileActionSlotLogic` | `setMobileActionSlotSettingBoxOpenToServer` | `self, settingBoxOpen, senderUserId` | server-only | 1-15 |
| `MobileActionSlotLogic` | `setMobileActionSlotsHiddenByMenu` | `self, hidden, immediate, duration` | client | 1-81 |
| `MobileActionSlotLogic` | `setMobileActionSlotsHiddenByToggle` | `self, hidden, immediate, duration` | client | 1-77 |
| `MobileActionSlotLogic` | `setMobileActionSlotsVisible` | `self, visible` | client | 1-37 |
| `MobileActionSlotLogic` | `setMobileActionSlotToggleVisible` | `self, visible` | client | 1-16 |
| `MobileActionSlotLogic` | `setSlotClient` | `self, slotKey, slotType, id` | client | 1-26 |
| `MobileActionSlotLogic` | `setSlotToServer` | `self, slotKey, slotType, id, keySet, senderUserId` | server-only | 1-40 |
| `MobileActionSlotLogic` | `startMobileActionSlotHoldTimer` | `self` | client | 1-11 |
| `MobileActionSlotLogic` | `stopAllMobileActionSlotPresses` | `self` | client | 1-39 |
| `MobileActionSlotLogic` | `stopMobileActionSlotHoldTimerIfIdle` | `self` | client | 1-12 |
| `MobileActionSlotLogic` | `switchMobileActionSlotKeySet` | `self` | client | 1-12 |
| `MobileActionSlotLogic` | `syncInitializedToClient` | `self, slotConfig, opacityPercent, settingBoxOpen` | client | 1-17 |
| `MobileActionSlotLogic` | `syncSetSlotToClient` | `self, slotKey, slotType, id, keySet` | client | 1-19 |
| `MobileActionSlotLogic` | `tryRegisterDraggedEntryToSlot` | `self, slotKey` | client | 1-34 |
| `MobileActionSlotLogic` | `tweenKeySwapScale` | `self, scale` | client | 1-31 |
| `MobileActionSlotLogic` | `tweenMobileActionSlotSettingScale` | `self, scale` | client | 1-30 |
| `MobileActionSlotLogic` | `tweenMobileActionSlotToggleScale` | `self, scale` | client | 1-23 |
| `MobileActionSlotLogic` | `tweenSlotScale` | `self, slotKey, scale` | client | 1-29 |
| `MobileActionSlotLogic` | `updateKeySetSprites` | `self` | client | 1-18 |
| `MobileActionSlotLogic` | `updateMobileActionSlotOpacityByScreenPoint` | `self, screenPoint` | client | 1-22 |
| `MobileActionSlotLogic` | `updateMobileActionSlotOpacityControls` | `self` | client | 1-26 |
| `MobileActionSlotLogic` | `updateMobileActionSlotToggleSprite` | `self` | client | 1-14 |
| `MobileActionSlotLogic` | `updateSlotCooldownVisual` | `self, slotKey` | client | 1-57 |
| `MobileUIMotionLogic` | `playFade` | `self, target, fromAlpha, toAlpha, duration, easeType` | client | 1-21 |
| `MobileUIMotionLogic` | `playScaleTo` | `self, target, toScale, duration, easeType` | client | 1-21 |
| `MobileUIMotionLogic` | `playSlide` | `self, target, isXAxis, fromValue, toValue, duration, easeType` | client | 1-26 |
| `MobileUIMotionLogic` | `playSlideCanvasGroupFade` | `self, target, isXAxis, fromValue, toValue, fromAlpha, toAlpha, duration, easeType` | client | 1-37 |
| `MobileUIMotionLogic` | `playSlideFade` | `self, target, isXAxis, fromValue, toValue, fromAlpha, toAlpha, duration, easeType` | client | 1-28 |
| `MobileUITransferLogic` | `appendToWarpData` | `self, warpDataTable, user` | server-only | 1-20 |
| `MobileUITransferLogic` | `applyWarpData` | `self, userEntity, warpDataTable` | server-only | 1-23 |
| `MobileUITransferLogic` | `copyWarpData` | `self, sourceWarpData, targetWarpData` | server-only | 1-18 |
| `MobileUITransferLogic` | `isValidMobileChatPos` | `self, saved, positionX, positionY` | server-only | 1-6 |
| `MobileUITransferLogic` | `parseMobileChatWarpPos` | `self, warpDataTable` | server-only | 1-20 |
| `MobileUITransferLogic` | `restoreMobileChatPosClient` | `self, saved, positionX, positionY` | client | 1-7 |
| `MobileUITransferLogic` | `restorePendingMobileChatPos` | `self, player, userId` | server-only | 1-20 |
| `MobileUITransferLogic` | `setMobileActionSlotSettingBoxOpen` | `self, user, settingBoxOpen` | server-only | 1-7 |
| `MobileUITransferLogic` | `setMobileChatPos` | `self, user, chatPos` | server-only | 1-19 |
| `MobileUITransferLogic` | `updateMobileChatPos` | `self, chatPos, senderUserId` | server-only | 1-8 |
| `MoonRabbit` | `cacheScriptFunc` | `self` | server-only | 1-10 |
| `MoonRabbit` | `moonrabbit` | `self, p` | server-only | 1-47 |
| `MoonRabbit` | `moonrabbit_bonus` | `self, p` | server-only | 1-41 |
| `MoonRabbit` | `moonrabbit_mobgen` | `self` | server-only | 1-7 |
| `MoonRabbit` | `moonrabbit_start` | `self` | server-only | 1-6 |
| `MoonRabbit` | `moonrabbit_takeawayitem` | `self, p` | server-only | 1-26 |
| `MoonRabbit` | `moonrabbit_tiger` | `self, p` | server-only | 1-67 |
| `MorphManager` | `getMorph` | `self, morphID` | client | 1-3 |
| `MorphManager` | `loadMorph` | `self` | client | 1-36 |
| `MotionDataManager` | `cacheMotionData` | `self, motionname, info` | client | 1-11 |
| `MotionDataManager` | `getMotionData` | `self, motionname` | client | 1-21 |
| `MotionDataManager` | `getMotionDelayAtAttackSpeed` | `self, motionname, attackSpeed` | client | 1-5 |
| `MotionDataManager` | `getMotionMinDelay` | `self, motionname` | client | 1-7 |
| `MotionDataManager` | `getMotionTotalDelaySec` | `self, motionname` | client | 1-10 |
| `MotionDataManager` | `loadMotion` | `self` | client | 1-17 |
| `MousePointerLogic` | `applyCursorPositionOffset` | `self, cursorPos, cursor` | client | 1-7 |
| `MousePointerLogic` | `applyCursorRenderer` | `self` | client | 1-27 |
| `MousePointerLogic` | `applyCursorState` | `self, stateName` | client | 1-28 |
| `MousePointerLogic` | `buildSingleFrameCursorState` | `self, ruid` | client | 1-20 |
| `MousePointerLogic` | `cacheCursorAnimations` | `self` | client | 1-25 |
| `MousePointerLogic` | `cacheDefaultCursorRUID` | `self` | client | 1-8 |
| `MousePointerLogic` | `cachePressedCursorRUID` | `self` | client | 1-8 |
| `MousePointerLogic` | `clearCursorOverrideRUID` | `self` | client | 1-14 |
| `MousePointerLogic` | `clearInvalidHoveredButton` | `self` | client | 1-21 |
| `MousePointerLogic` | `clearInvalidHoveredNpc` | `self` | client | 1-10 |
| `MousePointerLogic` | `connectHoverCleanupTimer` | `self` | client | 1-4 |
| `MousePointerLogic` | `connectMouseClickEvents` | `self` | client | 1-5 |
| `MousePointerLogic` | `connectMouseMoveEvent` | `self` | client | 1-4 |
| `MousePointerLogic` | `disconnectHoverCleanupTimer` | `self` | client | 1-6 |
| `MousePointerLogic` | `disconnectMouseClickEvents` | `self` | client | 1-10 |
| `MousePointerLogic` | `disconnectMouseMoveEvent` | `self` | client | 1-6 |
| `MousePointerLogic` | `ensureCursorEntity` | `self` | client | 1-44 |
| `MousePointerLogic` | `getDefaultCursorRUID` | `self` | client | 1-10 |
| `MousePointerLogic` | `getEmptySpriteTemplate` | `self` | client | 1-8 |
| `MousePointerLogic` | `getMousePointerFallbackParent` | `self` | client | 1-7 |
| `MousePointerLogic` | `getMousePointerParent` | `self` | client | 1-11 |
| `MousePointerLogic` | `getPressedCursorRUID` | `self` | client | 1-10 |
| `MousePointerLogic` | `handleHoverCleanupTimer` | `self` | client | 1-5 |
| `MousePointerLogic` | `initialize` | `self` | client | 1-31 |
| `MousePointerLogic` | `isCursorInsideUIEntity` | `self, target` | client | 1-28 |
| `MousePointerLogic` | `isItemSkillTooltipCursorActive` | `self` | client | 1-3 |
| `MousePointerLogic` | `moveCursorToTopInParent` | `self` | client | 1-20 |
| `MousePointerLogic` | `OnEndPlay` | `self` | client | 1-5 |
| `MousePointerLogic` | `onItemSkillTooltipHidden` | `self` | client | 1-9 |
| `MousePointerLogic` | `onItemSkillTooltipShown` | `self` | client | 1-4 |
| `MousePointerLogic` | `onMousePointerKeyDown` | `self, event` | client | 1-23 |
| `MousePointerLogic` | `onMousePointerKeyUp` | `self, event` | client | 1-31 |
| `MousePointerLogic` | `onUIButtonHover` | `self, button, cursorState` | client | 1-8 |
| `MousePointerLogic` | `onUIButtonHoverExit` | `self, button` | client | 1-13 |
| `MousePointerLogic` | `onUIElementPicked` | `self` | client | 1-4 |
| `MousePointerLogic` | `onUIElementReleased` | `self` | client | 1-4 |
| `MousePointerLogic` | `OnUpdate` | `self, delta` | client | 1-17 |
| `MousePointerLogic` | `refreshCursorState` | `self` | client | 1-29 |
| `MousePointerLogic` | `refreshPublishedCursor` | `self` | client | 1-6 |
| `MousePointerLogic` | `setCursorOverrideRUID` | `self, ruid` | client | 1-21 |
| `MousePointerLogic` | `tryTouchHoveredSummonTest` | `self` | client | 1-10 |
| `MousePointerLogic` | `updateHoveredNpc` | `self` | client | 1-50 |
| `MousePointerLogic` | `updateMousePointerPosition` | `self` | client | 1-22 |
| `NametagLogic` | `createNametag` | `self, type, parentEntity, name, nametagRUID, offset, textColor` | client | 1-83 |
| `NametagLogic` | `drawNametag` | `self, type, parentEntity, name, subName, nametagRUID, textColor` | client | 1-58 |
| `NametagLogic` | `getNametagEntity` | `self, type, targetEntity` | client | 1-10 |
| `NametagLogic` | `removeNametag` | `self, type, parentEntity` | client | 1-13 |
| `NinjaBoss` | `addRestrictedMember` | `self, name` | server-only | 1-9 |
| `NinjaBoss` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `NinjaBoss` | `canTryNinjaBossThisWeek` | `self, player` | server-only | 1-4 |
| `NinjaBoss` | `canTryThisWeek` | `self, player, weekRecordKey, tryRecordKey, tryLimit` | server-only | 1-3 |
| `NinjaBoss` | `clearExpedition` | `self` | server-only | 1-7 |
| `NinjaBoss` | `clearRecruitmentTimer` | `self` | server-only | 1-7 |
| `NinjaBoss` | `createExpedition` | `self, leaderName` | server-only | 1-7 |
| `NinjaBoss` | `createNinjaCastleTradeEquip` | `self, itemId` | server-only | 1-15 |
| `NinjaBoss` | `expireExpedition` | `self` | server-only | 1-10 |
| `NinjaBoss` | `forceRemoveExpeditionMember` | `self, p, udc` | server-only | 1-43 |
| `NinjaBoss` | `getExpeditionMemberList` | `self` | server-only | 1-14 |
| `NinjaBoss` | `getNinjaBossFieldSet` | `self` | server-only | 1-4 |
| `NinjaBoss` | `getNinjaBossWeeklyTryCount` | `self, player` | server-only | 1-4 |
| `NinjaBoss` | `getPartyLimitedMemberNames` | `self, users` | server-only | 1-11 |
| `NinjaBoss` | `getReadyExpeditionUsers` | `self` | server-only | 1-22 |
| `NinjaBoss` | `getWeeklyLimitedMemberNames` | `self, users` | server-only | 1-4 |
| `NinjaBoss` | `getWeeklyLimitedMemberNamesByRecord` | `self, users, weekRecordKey, tryRecordKey, tryLimit` | server-only | 1-9 |
| `NinjaBoss` | `getWeeklyTryCount` | `self, player, weekRecordKey, tryRecordKey, tryLimit` | server-only | 1-12 |
| `NinjaBoss` | `isExpeditionMember` | `self, name` | server-only | 1-10 |
| `NinjaBoss` | `isFieldSetOccupied` | `self, fieldSet` | server-only | 1-12 |
| `NinjaBoss` | `isNinjaBossOccupied` | `self, fieldSet` | server-only | 1-4 |
| `NinjaBoss` | `isNinjaBossPartyEligible` | `self, player, requireLeader` | server-only | 1-24 |
| `NinjaBoss` | `isRestrictedMember` | `self, name` | server-only | 1-10 |
| `NinjaBoss` | `ninja_Boss` | `self, p, udc` | server-only | 1-113 |
| `NinjaBoss` | `ninja_maze` | `self, p, udc` | server-only | 1-8 |
| `NinjaBoss` | `OnEndPlay` | `self` | server-only | 1-4 |
| `NinjaBoss` | `recordNinjaBossWeeklyTry` | `self, player` | server-only | 1-8 |
| `NinjaBoss` | `recordWeeklyTry` | `self, player, weekRecordKey, tryRecordKey, tryLimit` | server-only | 1-9 |
| `NinjaBoss` | `releaseRestrictedMember` | `self, p, udc` | server-only | 1-27 |
| `NinjaBoss` | `removeExpeditionMember` | `self, name` | server-only | 1-9 |
| `NinjaBoss` | `startExpedition` | `self, p, udc` | server-only | 1-85 |
| `NinjaBoss` | `trade_ninjaCastle` | `self, p, udc` | server-only | 1-51 |
| `NinjaBoss` | `validateExpeditionMemberCount` | `self, udc, memberCount` | server-only | 1-14 |
| `NpcConstants` | `checkCanSpawn` | `self, npcID` | client | 1-3 |
| `NpcConstants` | `OnBeginPlay` | `self` | server-only | 1-5 |
| `NpcManager` | `buildNpcDefaultAction` | `self, info` | client | 1-37 |
| `NpcManager` | `ensureNpcLoaded` | `self, npcId` | client | 1-58 |
| `NpcManager` | `ensureScriptIndexBuilt` | `self` | client | 1-39 |
| `NpcManager` | `getMatchedNpcQuestCondition` | `self, npcId, questComponent` | client | 1-32 |
| `NpcManager` | `getNpcAction` | `self, npcId, key` | client | 1-8 |
| `NpcManager` | `getNpcDefaultAction` | `self, npcId` | client | 1-23 |
| `NpcManager` | `getNpcDefaultTemplate` | `self, npcId` | client | 1-16 |
| `NpcManager` | `getNpcIdByScriptName` | `self, scriptName` | client | 1-8 |
| `NpcManager` | `getNpcInfo` | `self, npcId` | client | 1-8 |
| `NpcManager` | `getNpcRandomAnims` | `self, npcId` | client | 1-19 |
| `NpcManager` | `isNonActionKey` | `self, key` | client | 1-3 |
| `NpcManager` | `isNpcVisibleForQuest` | `self, npcId, questComponent` | client | 1-13 |
| `NpcManager` | `isQuestConditionKey` | `self, key` | client | 1-3 |
| `NpcManager` | `isQuestConditionNpc` | `self, npcId` | client | 1-4 |
| `NpcManager` | `loadNpc` | `self` | client | 1-11 |
| `NpcManager` | `loadNpcFull` | `self` | client | 1-72 |
| `NpcManager` | `loadNpcLazy` | `self` | client | 1-35 |
| `NpcManager` | `loadQuestConditionNpcIds` | `self` | client | 1-20 |
| `NpcManager` | `makeNpcInfo` | `self, npcId, dir` | client | 1-61 |
| `NpcManager` | `parseNpcQuestCondition` | `self, key, dir` | client | 1-14 |
| `NpcManager` | `sortNpcQuestConditions` | `self, conditions` | client | 1-7 |
| `NumberUtils` | `crossProduct` | `self, vec1, vec2` | client | 1-3 |
| `NumberUtils` | `getGenderFromID` | `self, itemID` | client | 1-17 |
| `NumberUtils` | `getTriggerBoxFromLtRb` | `self, lt, rb, left` | client | 1-19 |
| `NumberUtils` | `intersectBox` | `self, b1, b2` | client | 1-30 |
| `NumberUtils` | `intersectRC` | `self, rc1, rc2` | client | 1-30 |
| `NumberUtils` | `makeBoxShapeFromLtRb` | `self, origin, lt, rb, left` | client | 1-4 |
| `NumberUtils` | `pointInBoxShape` | `self, x, y, boxShape` | client | 1-20 |
| `NumberUtils` | `pointInRect` | `self, pt, rc` | client | 1-3 |
| `NumberUtils` | `triggerToBox` | `self, t` | client | 1-3 |
| `ObjectPool` | `clear` | `self, pool` | client | 1-10 |
| `ObjectPool` | `pick` | `self, pool, objName, modelId, pos, parent, enable` | client | 1-39 |
| `ObjectPool` | `release` | `self, pool, entity, forceRelease` | client | 1-14 |
| `ObserverUtilLogic` | `ApplyMobileGameplayUI` | `self` | client | 1-53 |
| `ObserverUtilLogic` | `ApplyObservedCharacterStatSnapshot_Client` | `self, data` | client | 1-6 |
| `ObserverUtilLogic` | `ApplyObservedQuickSlotSnapshot_Client` | `self, data` | client | 1-6 |
| `ObserverUtilLogic` | `ApplyObserverCameraZoom` | `self` | client | 1-12 |
| `ObserverUtilLogic` | `ApplyObserverDesktopUI` | `self` | client | 1-60 |
| `ObserverUtilLogic` | `BuildObservedCharacterStatSnapshot_ServerOnly` | `self, user` | server-only | 1-100 |
| `ObserverUtilLogic` | `BuildObservedQuickSlotSnapshot_ServerOnly` | `self, user` | server-only | 1-24 |
| `ObserverUtilLogic` | `FormatObservedStat_ServerOnly` | `self, baseValue, addValue, tempValue` | server-only | 1-8 |
| `ObserverUtilLogic` | `GetFullAuto` | `self` | client | 1-3 |
| `ObserverUtilLogic` | `GetObservedMapName` | `self` | client | 1-16 |
| `ObserverUtilLogic` | `GetObservedTempStatValue_ServerOnly` | `self, user, flag` | server-only | 1-6 |
| `ObserverUtilLogic` | `GetObservedUserInfo` | `self` | client | 1-22 |
| `ObserverUtilLogic` | `GetObserverAdminIds` | `self` | server-only | 1-13 |
| `ObserverUtilLogic` | `GetObserverUsersId` | `self, observedUserId` | server-only | 1-28 |
| `ObserverUtilLogic` | `GetObserverUsersIdByMapName` | `self, mapName` | server-only | 1-18 |
| `ObserverUtilLogic` | `GetUserIdsByMapNameWithObservers` | `self, mapName` | server-only | 1-42 |
| `ObserverUtilLogic` | `HandleKeyHoldEvent` | `self, event` | client | 1-11 |
| `ObserverUtilLogic` | `HandleObserveUserWorldRequestResult_ServerOnly` | `self, result, t, observedUserProfileCode, observerUserId` | server-only | 1-63 |
| `ObserverUtilLogic` | `InitializeCamSetting` | `self` | client | 1-15 |
| `ObserverUtilLogic` | `IsAdmin` | `self, userId` | server-only | 1-5 |
| `ObserverUtilLogic` | `IsObserverDesktopUIActive` | `self` | client | 1-4 |
| `ObserverUtilLogic` | `MoveCamera` | `self, dir` | client | 1-24 |
| `ObserverUtilLogic` | `ObserveMap` | `self, mapName, observerUserProfileCode` | client | 1-3 |
| `ObserverUtilLogic` | `ObserveMap_Server` | `self, mapName, observerUserProfileCode, senderUserId` | server-only | 1-11 |
| `ObserverUtilLogic` | `ObserveMap_ServerOnly` | `self, mapName, observerUserProfileCode` | server-only | 1-3 |
| `ObserverUtilLogic` | `ObserveUser` | `self, observedUserProfileCode, observerUserProfileCode` | client | 1-3 |
| `ObserverUtilLogic` | `ObserveUser_Server` | `self, observedUserProfileCode, observerUserProfileCode, senderUserId` | server-only | 1-15 |
| `ObserverUtilLogic` | `ObserveUser_ServerOnly` | `self, observedUserProfileCode, observerUserProfileCode` | server-only | 1-16 |
| `ObserverUtilLogic` | `ObserveUserOrWarp_ServerOnly` | `self, observedUserProfileCode, observerUserProfileCode, observerUserId` | server-only | 1-15 |
| `ObserverUtilLogic` | `OnBeginPlay` | `self` | server-only | 1-6 |
| `ObserverUtilLogic` | `OnSyncFullAuto` | `self, isFullAuto` | client | 1-3 |
| `ObserverUtilLogic` | `OnSyncStopObserve` | `self` | client | 1-14 |
| `ObserverUtilLogic` | `OnUpdate` | `self, delta` | client | 1-25 |
| `ObserverUtilLogic` | `PrepareAutoObserveAfterWarp` | `self, observedUserKey` | client | 1-10 |
| `ObserverUtilLogic` | `RefreshObserverClientUI` | `self, isObserving` | client | 1-31 |
| `ObserverUtilLogic` | `RefreshObserverPresentationState` | `self` | client | 1-41 |
| `ObserverUtilLogic` | `RequestObservedCharacterStatSnapshot_Server` | `self, senderUserId` | server-only | 1-26 |
| `ObserverUtilLogic` | `RequestObservedQuickSlotSnapshot_Server` | `self, senderUserId` | server-only | 1-26 |
| `ObserverUtilLogic` | `RequestObserveUserInOtherInstance_ServerOnly` | `self, observedUserProfileCode, observerUserId` | server-only | 1-27 |
| `ObserverUtilLogic` | `ResolveObservedUserProfileCode_ServerOnly` | `self, observedUserKey` | server-only | 1-20 |
| `ObserverUtilLogic` | `SetActiveObserverUtilsEntity` | `self, parent, isActive` | client | 1-34 |
| `ObserverUtilLogic` | `SetFullAuto` | `self, isFullAuto` | client | 1-4 |
| `ObserverUtilLogic` | `SetFullAuto_Server` | `self, isFullAuto, senderUserId` | server-only | 1-6 |
| `ObserverUtilLogic` | `SetFullAuto_ServerOnly` | `self, observerUserId, isFullAuto, needSync` | server-only | 1-11 |
| `ObserverUtilLogic` | `SetObserverPanelOpen` | `self, isOpen` | client | 1-5 |
| `ObserverUtilLogic` | `SetObserverPlatformUIEntity` | `self, path, enable` | client | 1-9 |
| `ObserverUtilLogic` | `SetObserverViewState` | `self, isObserving` | client | 1-5 |
| `ObserverUtilLogic` | `StartObservedUserAttackLog_ServerOnly` | `self, observedUserProfileCode, observerUserProfileCode` | server-only | 1-14 |
| `ObserverUtilLogic` | `StopObserve` | `self, observerUserProfileCode` | client | 1-3 |
| `ObserverUtilLogic` | `StopObserve_Server` | `self, observerUserProfileCode, senderUserId` | server-only | 1-7 |
| `ObserverUtilLogic` | `StopObserve_ServerOnly` | `self, observerUserProfileCode` | server-only | 1-10 |
| `ObserverUtilLogic` | `StopObservedUserAttackLog_ServerOnly` | `self, observerUserProfileCode` | server-only | 1-8 |
| `ObserverUtilLogic` | `SyncFullAuto` | `self, userId, isFullAuto, senderUserId` | server-only | 1-3 |
| `ObserverUtilLogic` | `SyncObservedQuickSlotToObserver_ServerOnly` | `self, observedUserProfileCode, observerUserProfileCode` | server-only | 1-13 |
| `ObserverUtilLogic` | `SyncObservedUserEquipmentToObserver_ServerOnly` | `self, observedUserProfileCode, observerUserProfileCode, retryCount` | server-only | 1-38 |
| `ObserverUtilLogic` | `SyncObservedUserMoveToInstanceRoom` | `self, observedUserProfileCode, instanceKey` | client | 1-9 |
| `ObserverUtilLogic` | `SyncObservedUserMoveToStaticRoom` | `self, observedUserProfileCode` | client | 1-7 |
| `ObserverUtilLogic` | `SyncObservedUserWarpWorldInstance` | `self, observedUserProfileCode, worldInstanceId` | client | 1-9 |
| `ObserverUtilLogic` | `SyncUserMapVisualsToObservers_ServerOnly` | `self, observedUserId` | server-only | 1-3 |
| `ObserverUtilLogic` | `SyncUserMapVisualsToObserversRetry_ServerOnly` | `self, observedUserId, retryCount` | server-only | 1-53 |
| `ObserverUtilLogic` | `TraceUser_InstanceRoom_ServerOnly` | `self, observerUserId, observedUserProfileCode, instanceKey` | server-only | 1-20 |
| `ObserverUtilLogic` | `TraceUser_StaticRoom_ServerOnly` | `self, observerUserId, observedUserProfileCode` | server-only | 1-17 |
| `ObserverUtilLogic` | `TraceUser_Warp_ServerOnly` | `self, observedUserProfileCode, newWorldInstanceId, userId` | server-only | 1-16 |
| `ObserverUtilLogic` | `TryAutoObserveFromUI` | `self, observedUserKey` | client | 1-13 |
| `OffsetUtils` | `bankerAdjust` | `self, size` | client | 1-10 |
| `OffsetUtils` | `calcNormalizedBox` | `self, lt, rb, left` | client | 1-32 |
| `OffsetUtils` | `calcScrollByCursorPos` | `self, scrollCount, scrollYSize, barBaseY, prevBaseY, prevButton` | client | 1-35 |
| `OffsetUtils` | `GetEvenPivotOffset` | `self, width, height, originX, originY, half` | client | 1-22 |
| `Ossyria` | `absence_box` | `self, player, udc` | server-only | 1-4 |
| `Ossyria` | `absence_desk` | `self, player, udc` | server-only | 1-4 |
| `Ossyria` | `absence_frame` | `self, player, udc` | server-only | 1-24 |
| `Ossyria` | `absence_wall` | `self, player, udc` | server-only | 1-20 |
| `Ossyria` | `adin_enter` | `self, player, udc` | server-only | 1-38 |
| `Ossyria` | `alcadno_potion` | `self, player, udc` | server-only | 1-16 |
| `Ossyria` | `alceCircle1` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `alceCircle2` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `alceCircle3` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `alceCircle4` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_gold1` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_gold2` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_gold3` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_gold4` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_house1` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_house2` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_house3` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_house4` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `ariant_oasis` | `self, player, udc` | server-only | 1-10 |
| `Ossyria` | `ariant_ring` | `self, player, udc` | server-only | 1-7 |
| `Ossyria` | `back_Ludi` | `self, player, udc` | server-only | 1-5 |
| `Ossyria` | `balog_inOut` | `self, player, udc` | server-only | 1-7 |
| `Ossyria` | `broadcastMapNotice` | `self, player, messageType, text` | server-only | 1-13 |
| `Ossyria` | `cacheScriptFunc` | `self` | server-only | 1-33 |
| `Ossyria` | `cejan` | `self, player, udc` | server-only | 1-18 |
| `Ossyria` | `dooat` | `self, player, udc` | server-only | 1-249 |
| `Ossyria` | `drang_room1` | `self, player, udc` | server-only | 1-23 |
| `Ossyria` | `earth009` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `earth010` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `earth011` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `earth012` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `earth013` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `earth014` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `FantasticPark_CableCar` | `self, player, udc` | server-only | 1-4 |
| `Ossyria` | `FantasticPark_Guide` | `self, player, udc` | server-only | 1-4 |
| `Ossyria` | `FantasticShow` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `flyminidraco` | `self, player, udc` | server-only | 1-15 |
| `Ossyria` | `forself` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `getAboard` | `self, player, udc` | server-only | 1-34 |
| `Ossyria` | `giveupTimer` | `self, player, udc` | server-only | 1-22 |
| `Ossyria` | `go_animalShow` | `self, player, udc` | server-only | 1-58 |
| `Ossyria` | `go_FantasticPark` | `self, player, udc` | server-only | 1-6 |
| `Ossyria` | `guildquest1_comment` | `self, player, udc` | server-only | 1-39 |
| `Ossyria` | `handleAlceCircle` | `self, player, requiredState, nextState, itemId, action, noticeText` | server-only | 1-30 |
| `Ossyria` | `handleAriantGold` | `self, player, udc, npcId` | server-only | 1-53 |
| `Ossyria` | `handleAriantHouseFood` | `self, player, udc, npcId` | server-only | 1-57 |
| `Ossyria` | `handleEarthSample` | `self, player, udc` | server-only | 1-47 |
| `Ossyria` | `handlePipe` | `self, player, udc, npcId` | server-only | 1-62 |
| `Ossyria` | `HighPriest` | `self, player, udc` | server-only | 1-57 |
| `Ossyria` | `in_FantasticPark` | `self, player, udc` | server-only | 1-40 |
| `Ossyria` | `in_ghostHouse` | `self, player, udc` | server-only | 1-6 |
| `Ossyria` | `jenu_homun` | `self, player, udc` | server-only | 1-29 |
| `Ossyria` | `job4_item` | `self, player, udc` | server-only | 1-172 |
| `Ossyria` | `karakasa` | `self, player, udc` | server-only | 1-25 |
| `Ossyria` | `lex` | `self, player, udc` | server-only | 1-30 |
| `Ossyria` | `library` | `self, player, udc` | server-only | 1-23 |
| `Ossyria` | `loveOath` | `self, player, udc` | server-only | 1-42 |
| `Ossyria` | `ludi014` | `self, player, udc` | server-only | 1-17 |
| `Ossyria` | `ludi015` | `self, player, udc` | server-only | 1-27 |
| `Ossyria` | `ludi016` | `self, player, udc` | server-only | 1-27 |
| `Ossyria` | `ludi017` | `self, player, udc` | server-only | 1-17 |
| `Ossyria` | `ludi020` | `self, player, udc` | server-only | 1-60 |
| `Ossyria` | `ludi023` | `self, player, udc` | server-only | 1-44 |
| `Ossyria` | `ludi024` | `self, player, udc` | server-only | 1-35 |
| `Ossyria` | `ludi026` | `self, player, udc` | server-only | 1-5 |
| `Ossyria` | `ludi027` | `self, player, udc` | server-only | 1-25 |
| `Ossyria` | `ludi028` | `self, player, udc` | server-only | 1-22 |
| `Ossyria` | `ludi029` | `self, player, udc` | server-only | 1-22 |
| `Ossyria` | `ludiEvent` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `magatia_dark1` | `self, player, udc` | server-only | 1-13 |
| `Ossyria` | `oldBook1` | `self, player, udc` | server-only | 1-58 |
| `Ossyria` | `oldBook2` | `self, player, udc` | server-only | 1-13 |
| `Ossyria` | `oldBook5` | `self, player, udc` | server-only | 1-46 |
| `Ossyria` | `ossyria3_1` | `self, player, udc` | server-only | 1-15 |
| `Ossyria` | `ossyria3_2` | `self, player, udc` | server-only | 1-15 |
| `Ossyria` | `out_animalShow` | `self, player, udc` | server-only | 1-11 |
| `Ossyria` | `out_ghostHouse` | `self, player, udc` | server-only | 1-6 |
| `Ossyria` | `outTemple` | `self, player, udc` | server-only | 1-7 |
| `Ossyria` | `pipe1` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `pipe2` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `pipe3` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `Populatus00` | `self, player, udc` | server-only | 1-131 |
| `Ossyria` | `Populatus01` | `self, player, udc` | server-only | 1-9 |
| `Ossyria` | `resetPipePassword` | `self, player` | server-only | 1-5 |
| `Ossyria` | `resetTamingMobBeforeDracoMorph` | `self, player` | server-only | 1-12 |
| `Ossyria` | `reundodraco` | `self, player, udc` | server-only | 1-5 |
| `Ossyria` | `secret_wall` | `self, player, udc` | server-only | 1-19 |
| `Ossyria` | `secretNPC` | `self, player, udc` | server-only | 1-46 |
| `Ossyria` | `shammos` | `self, player, udc` | server-only | 1-20 |
| `Ossyria` | `shammos2` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `shammos_Original` | `self, player, udc` | server-only | 1-3 |
| `Ossyria` | `shammos_Potion` | `self, player, udc` | server-only | 1-11 |
| `Ossyria` | `shuffleString` | `self, text` | server-only | 1-13 |
| `Ossyria` | `Sky_Train` | `self, player, udc` | server-only | 1-6 |
| `Ossyria` | `snow_rose` | `self, player, udc` | server-only | 1-33 |
| `Ossyria` | `TD_neo_Andy` | `self, player, udc` | server-only | 1-4 |
| `Ossyria` | `TD_neoCity_enter` | `self, player, udc` | server-only | 1-63 |
| `Ossyria` | `templeenter` | `self, player, udc` | server-only | 1-6 |
| `Ossyria` | `thief_in2` | `self, player, udc` | server-only | 1-24 |
| `Ossyria` | `timeQuest` | `self, player, udc` | server-only | 1-91 |
| `Ossyria` | `undodraco` | `self, player, udc` | server-only | 1-11 |
| `Party1_Script` | `area_check` | `self, player, num, user` | server-only | 1-13 |
| `Party1_Script` | `cacheScriptFunc` | `self` | server-only | 1-10 |
| `Party1_Script` | `check_stage` | `self, player, udc, st, checkall` | server-only | 1-16 |
| `Party1_Script` | `party1_enter` | `self, user, udc` | server-only | 1-19 |
| `Party1_Script` | `party1_help` | `self, player, udc` | server-only | 1-12 |
| `Party1_Script` | `party1_out` | `self, user, udc` | server-only | 1-40 |
| `Party1_Script` | `party1_personal` | `self, player, udc` | server-only | 1-66 |
| `Party1_Script` | `party1_play` | `self, user, udc` | server-only | 1-21 |
| `Party1_Script` | `party1_reward` | `self, player, udc` | server-only | 1-67 |
| `Party1_Script` | `party1_stage1` | `self, player, udc` | server-only | 1-34 |
| `Party1_Script` | `party1_stage2` | `self, player, udc` | server-only | 1-27 |
| `Party1_Script` | `party1_stage3` | `self, player, udc` | server-only | 1-27 |
| `Party1_Script` | `party1_stage4` | `self, player, udc` | server-only | 1-27 |
| `Party1_Script` | `party1_stage5` | `self, player, udc` | server-only | 1-18 |
| `Party1_Script` | `shuffle` | `self, str` | server-only | 1-19 |
| `Party2_Script` | `area_check` | `self, p, num, user` | server-only | 1-13 |
| `Party2_Script` | `cacheScriptFunc` | `self` | server-only | 1-10 |
| `Party2_Script` | `check_stage` | `self, p, udc, st, checkall` | server-only | 1-16 |
| `Party2_Script` | `party2_enter` | `self, p, udc` | server-only | 1-87 |
| `Party2_Script` | `party2_help` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_out` | `self, p, udc` | server-only | 1-33 |
| `Party2_Script` | `party2_play` | `self, p, udc` | server-only | 1-36 |
| `Party2_Script` | `party2_reward` | `self, p, udc` | server-only | 1-235 |
| `Party2_Script` | `party2_stage1` | `self, p, udc` | server-only | 1-32 |
| `Party2_Script` | `party2_stage2` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_stage3` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_stage4` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_stage5` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_stage6` | `self, p, udc` | server-only | 1-23 |
| `Party2_Script` | `party2_stage7` | `self, p, udc` | server-only | 1-24 |
| `Party2_Script` | `party2_stage8` | `self, p, udc` | server-only | 1-29 |
| `Party2_Script` | `party2_stage9` | `self, p, udc` | server-only | 1-66 |
| `Party2_Script` | `party2_takwawayitem` | `self, p` | server-only | 1-8 |
| `Party2_Script` | `shuffle` | `self, str` | server-only | 1-19 |
| `Party2_Script` | `stage6_portal` | `self, p, udc` | server-only | 1-4 |
| `Party3_Script` | `ate_food` | `self, p, code` | server-only | 1-80 |
| `Party3_Script` | `cacheScriptFunc` | `self` | server-only | 1-11 |
| `Party3_Script` | `clearmission` | `self, p` | server-only | 1-26 |
| `Party3_Script` | `clearmission2` | `self, p, nNum` | server-only | 1-62 |
| `Party3_Script` | `cMission_reward` | `self, p, code` | server-only | 1-45 |
| `Party3_Script` | `feellike` | `self, p, item` | server-only | 1-151 |
| `Party3_Script` | `feellike_reward` | `self, p, like` | server-only | 1-66 |
| `Party3_Script` | `food_code` | `self, code` | server-only | 1-10 |
| `Party3_Script` | `party3_enter` | `self, p` | server-only | 1-228 |
| `Party3_Script` | `party3_gardenin` | `self, p` | server-only | 1-16 |
| `Party3_Script` | `party3_help` | `self, p` | server-only | 1-38 |
| `Party3_Script` | `party3_jail1` | `self, p` | server-only | 1-12 |
| `Party3_Script` | `party3_jail2` | `self, p` | server-only | 1-12 |
| `Party3_Script` | `party3_jail3` | `self, p` | server-only | 1-12 |
| `Party3_Script` | `party3_jailin` | `self, p, arg1, portal` | server-only | 1-24 |
| `Party3_Script` | `party3_minerva` | `self, p` | server-only | 1-112 |
| `Party3_Script` | `party3_nQuizAns` | `self, p` | server-only | 1-35 |
| `Party3_Script` | `party3_out` | `self, p` | server-only | 1-28 |
| `Party3_Script` | `party3_play` | `self, p` | server-only | 1-327 |
| `Party3_Script` | `party3_r4pt` | `self, p, udc, portal` | server-only | 1-50 |
| `Party3_Script` | `party3_r6pt` | `self, p, arg1, portal` | server-only | 1-509 |
| `Party3_Script` | `party3_room1` | `self, p` | server-only | 1-27 |
| `Party3_Script` | `party3_room2` | `self, p` | server-only | 1-27 |
| `Party3_Script` | `party3_room3` | `self, p` | server-only | 1-27 |
| `Party3_Script` | `party3_room4` | `self, p` | server-only | 1-27 |
| `Party3_Script` | `party3_room5` | `self, p` | server-only | 1-28 |
| `Party3_Script` | `party3_room6` | `self, p` | server-only | 1-57 |
| `Party3_Script` | `party3_room8` | `self, p` | server-only | 1-21 |
| `Party3_Script` | `party3_roomout` | `self, p, arg1, portal` | server-only | 1-45 |
| `Party3_Script` | `party3_takeawayitem` | `self, p` | server-only | 1-13 |
| `Party3_Script` | `party_check` | `self, p` | server-only | 1-11 |
| `Party3_Script` | `premission` | `self, p` | server-only | 1-26 |
| `Party3_Script` | `shuffle` | `self, str` | server-only | 1-19 |
| `PartyManager` | `broadCastingPartyRequest` | `self, type, partyId, senderPlayerId, pm, chatMsg` | server-only | 1-15 |
| `PartyManager` | `dispatchPartyRequestToUser` | `self, type, partyId, user, userId, pm, chatMsg` | server-only | 1-29 |
| `PartyManager` | `getPartyMemberCount` | `self, members` | client | 1-11 |
| `PartyManager` | `invitedParty` | `self, level, job, name, partyId, inviterId` | client | 1-11 |
| `PartyManager` | `invitePartyToServer` | `self, user, userId, receiverName` | server-only | 1-81 |
| `PartyManager` | `responseInviteParty` | `self, response, partyId, inviterId, responderName, responderId, senderUserId` | server-only | 1-117 |
| `PartyManager` | `tryChangeLeader` | `self, prevLeaderName, newLeaderName, senderUserId` | server-only | 1-56 |
| `PartyManager` | `tryCreateParty` | `self, senderUserId` | server-only | 1-26 |
| `PartyManager` | `tryDispatchPartyRequestLocal` | `self, type, partyId, senderPlayerId, pm, chatMsg` | server-only | 1-51 |
| `PartyManager` | `tryInviteParty` | `self, receiverName` | client | 1-34 |
| `PartyManager` | `tryInvitePartyToServer` | `self, receiverName, senderUserId` | server-only | 1-59 |
| `PartyManager` | `tryKickMember` | `self, name, senderUserId` | server-only | 1-45 |
| `PartyManager` | `tryLeaveParty` | `self, senderUserId` | server-only | 1-46 |
| `PartyManager` | `updatePartyMemberMinimapIcon` | `self, target` | client | 1-7 |
| `PendingMessageService` | `getPendingMessages` | `self, playerId` | server-only | 1-17 |
| `PendingMessageService` | `popPending` | `self, playerId, removeId` | server-only | 1-11 |
| `PendingMessageService` | `pushPending` | `self, playerId, msg, callback` | server-only | 1-34 |
| `PetEXPTable` | `getMaxExp` | `self, level` | server-only | 1-3 |
| `PetEXPTable` | `OnBeginPlay` | `self` | server-only | 1-32 |
| `Physics` | `getWingsFallSpeedMaxY` | `self, skillID, skillLevel` | client | 1-9 |
| `PinkBeen` | `cacheScriptFunc` | `self` | server-only | 1-35 |
| `PinkBeen` | `PinkBeen_Out` | `self, player, udc` | server-only | 1-7 |
| `PinkBeen` | `PinkBeen_Summon` | `self, player, udc` | server-only | 1-26 |
| `PinkBeen` | `Pinkin` | `self, player, udc` | server-only | 1-5 |
| `PinkBeen` | `PPinkOut` | `self, player, udc` | server-only | 1-5 |
| `Pinkbean0` | `cacheScriptFunc` | `self` | server-only | 1-39 |
| `Pinkbean0` | `getStrReg` | `self, reg` | server-only | 1-4 |
| `Pinkbean0` | `pinkbean_ban` | `self, p, udc` | server-only | 1-429 |
| `Pinkbean0` | `pinkbean_ban2` | `self, p, name, udc` | server-only | 1-55 |
| `Pinkbean0` | `pinkbean_bancheck` | `self, cName` | server-only | 1-10 |
| `Pinkbean0` | `pinkbean_banned` | `self, cName, udc` | server-only | 1-8 |
| `Pinkbean0` | `pinkbean_check` | `self, cName` | server-only | 1-10 |
| `Pinkbean0` | `pinkbean_clearReg` | `self` | server-only | 1-53 |
| `Pinkbean0` | `pinkbean_entercheck` | `self, p` | server-only | 1-11 |
| `Pinkbean0` | `pinkbean_entercheck2` | `self, udc` | server-only | 1-9 |
| `Pinkbean0` | `pinkbean_enterMsg` | `self` | server-only | 1-8 |
| `Pinkbean0` | `pinkbean_expeditionEndMsg` | `self` | server-only | 1-9 |
| `Pinkbean0` | `pinkbean_getname` | `self, udc` | server-only | 1-14 |
| `Pinkbean0` | `pinkbean_in` | `self, cName, udc` | server-only | 1-40 |
| `Pinkbean0` | `pinkbean_master` | `self, p, udc` | server-only | 1-10 |
| `Pinkbean0` | `pinkbean_noban` | `self, p, udc` | server-only | 1-103 |
| `Pinkbean0` | `pinkbean_out1` | `self, cName, udc` | server-only | 1-99 |
| `Pinkbean0` | `pinkbean_partycheck` | `self, p, udc` | server-only | 1-14 |
| `Pinkbean0` | `pinkbean_reset` | `self` | server-only | 1-10 |
| `Pinkbean0` | `pinkbean_timecheck` | `self, p, udc` | server-only | 1-15 |
| `Pinkbean0` | `PinkBeen_accept` | `self, p, udc` | server-only | 1-243 |
| `Pinkbean0` | `setStrReg` | `self, reg, value` | server-only | 1-4 |
| `PlayerAttackLogic` | `actionPlayerAttackClient` | `self, attacker, sad, soulArrowSkillID` | client | 1-416 |
| `PlayerAttackLogic` | `afterDead` | `self, attacker, mob, delay` | server-only | 1-95 |
| `PlayerAttackLogic` | `applyPendingWindWalkAttackBoost` | `self, attacker, sad` | client | 1-10 |
| `PlayerAttackLogic` | `applyServerAttackResult` | `self, targetData, damages, criticals, skillID` | server-only | 1-17 |
| `PlayerAttackLogic` | `beforeAttackMob` | `self, attacker, mob, skillID, skillLevel, totalDamage, delay` | server-only | 1-37 |
| `PlayerAttackLogic` | `broadcastPlayerAttack` | `self, attacker, sad` | server-only | 1-14 |
| `PlayerAttackLogic` | `calcDamage` | `self, attacker, mob, skillID, skillLevel, attackCount, attackMotion, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack` | server-only | 1-11 |
| `PlayerAttackLogic` | `calcDamageClient` | `self, attacker, mob, skillID, skillLevel, attackCount, damageDelays, attackMotion, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack` | client | 1-42 |
| `PlayerAttackLogic` | `canUseAttackSkillByCooldown` | `self, attacker, skillID, skillLevelData, currentTime` | client | 1-14 |
| `PlayerAttackLogic` | `canUseVanishAttackBoost` | `self, attacker` | client | 1-7 |
| `PlayerAttackLogic` | `checkCanAttack` | `self, attacker, skillID` | client | 1-41 |
| `PlayerAttackLogic` | `checkWeapon` | `self, weapon, weaponItem` | client | 1-7 |
| `PlayerAttackLogic` | `clearAttackDamages` | `self, damages, criticals` | client | 1-8 |
| `PlayerAttackLogic` | `clearAttackInfoClient` | `self` | client | 1-4 |
| `PlayerAttackLogic` | `clearUserAttackLogWatcher` | `self, watcherUserId` | server-only | 1-10 |
| `PlayerAttackLogic` | `decreaseSparkChainAttackCounter` | `self, attacker, sad, now` | server-only | 1-44 |
| `PlayerAttackLogic` | `displayDamage` | `self, attacker, mob, damages, criticals, delays, senderUserId` | server-only | 1-12 |
| `PlayerAttackLogic` | `displayDamageByAttackerClient` | `self, attacker, mob, damages, criticals, delays` | client | 1-6 |
| `PlayerAttackLogic` | `displayDamageClient` | `self, mob, damages, criticals, delays, attacker` | client | 1-6 |
| `PlayerAttackLogic` | `displayOtherDamageClient` | `self, mob, damages, criticals, delays, attacker` | client | 1-11 |
| `PlayerAttackLogic` | `displaySkillDamageByAttackerClient` | `self, attacker, mob, skillID, damages, criticals, delays` | client | 1-11 |
| `PlayerAttackLogic` | `doNormalAttack` | `self, attacker, isShoot` | server-only | 1-85 |
| `PlayerAttackLogic` | `doPlayerAttack` | `self, attacker, sad, skillLevelData, handleAttackCooldown` | server-only | 1-103 |
| `PlayerAttackLogic` | `dropItemByMob` | `self, mob, owner, ownType, partyId, delay` | server-only | 1-276 |
| `PlayerAttackLogic` | `dropItemBySteal` | `self, mob, user` | server-only | 1-134 |
| `PlayerAttackLogic` | `findValidHitReactor` | `self, attacker, position, size, angle` | client | 1-19 |
| `PlayerAttackLogic` | `findValidMobs` | `self, attacker, position, size, angle, mobCount, isHeal, mobBoxScale` | client | 1-173 |
| `PlayerAttackLogic` | `getAttackPlayRate` | `self, attacker, skillID` | client | 1-5 |
| `PlayerAttackLogic` | `getAttackType` | `self, attacker, skillID, weaponInfo` | client | 1-24 |
| `PlayerAttackLogic` | `getExpectedAttackHitCountServer` | `self, attacker, skillID, attackType, levelData` | server-only | 1-72 |
| `PlayerAttackLogic` | `getExpectedAttackHitsServer` | `self, attacker, sad, ld` | server-only | 1-33 |
| `PlayerAttackLogic` | `getHitOffset` | `self, mob, playerPos, mobPos, box, playerFaceLeft, mobFaceLeft, isRelativeOffset` | client | 1-54 |
| `PlayerAttackLogic` | `getHitPlayDelay` | `self, totalFrameDelay, hitIndex, totalHits` | client | 1-5 |
| `PlayerAttackLogic` | `getHitPoint` | `self, mob, box` | client | 1-11 |
| `PlayerAttackLogic` | `getMobVisualCenterOffset` | `self, mob` | client | 1-20 |
| `PlayerAttackLogic` | `getMobVisualCenterWorldPos` | `self, mob` | client | 1-7 |
| `PlayerAttackLogic` | `getRandomAttackMotion` | `self, attacker, weaponInfo, shoot` | client | 1-22 |
| `PlayerAttackLogic` | `getServerActionLockFallbackDelay` | `self, sad` | client | 1-6 |
| `PlayerAttackLogic` | `getServerActionLockPrepareDelay` | `self, sad` | client | 1-8 |
| `PlayerAttackLogic` | `getSkillActionLockSoftGrace` | `self, serverDelay, clientDelay` | client | 1-4 |
| `PlayerAttackLogic` | `getSkillActionLockStrongGrace` | `self, serverDelay, clientDelay` | client | 1-4 |
| `PlayerAttackLogic` | `getSkillMinDelay` | `self, skillID` | client | 1-63 |
| `PlayerAttackLogic` | `getWeaponInfo` | `self, attacker` | client | 1-33 |
| `PlayerAttackLogic` | `hasComboTempestTemporaryStat` | `self, mob` | client | 1-6 |
| `PlayerAttackLogic` | `increaseSparkChainAttackCounter` | `self, attacker, sad, now` | server-only | 1-23 |
| `PlayerAttackLogic` | `isComboTempestStatusOnlyTarget` | `self, skillID, mob` | client | 1-12 |
| `PlayerAttackLogic` | `isFinalAttackActionLockSkill` | `self, skillID` | client | 1-12 |
| `PlayerAttackLogic` | `isFirstAttack` | `self, index` | client | 1-3 |
| `PlayerAttackLogic` | `isMeleeAttackSkill` | `self, skillID` | client | 1-28 |
| `PlayerAttackLogic` | `isProneAttackBlockedSkill` | `self, skillID` | client | 1-6 |
| `PlayerAttackLogic` | `isSanctuarySkill` | `self, skillID` | client | 1-3 |
| `PlayerAttackLogic` | `isShadowPartnerJobGroup` | `self, attacker` | server-only | 1-10 |
| `PlayerAttackLogic` | `isShootAttackSkill` | `self, skillID` | client | 1-15 |
| `PlayerAttackLogic` | `isSkillLtRbUnionBoxCheckSkipSkill` | `self, skillID` | server-only | 1-6 |
| `PlayerAttackLogic` | `logAttackHitCountServer` | `self, attacker, sad, hits, expectedHits` | server-only | 1-55 |
| `PlayerAttackLogic` | `logSkillLtRbUnionBoxMiss` | `self, attacker, mob, sad, skillLevelData, targetIndex` | server-only | 1-95 |
| `PlayerAttackLogic` | `makeHitDelayInfo` | `self, pa, ctx, afterimageSprites` | client | 1-151 |
| `PlayerAttackLogic` | `notifyUserAttackLog` | `self, attacker, sad, totalDamage, targets, hits` | server-only | 1-4 |
| `PlayerAttackLogic` | `notifyUserAttackLogSummary` | `self, attacker, skillID, skillLevel, totalDamage, targets, hits, source, attackType` | server-only | 1-47 |
| `PlayerAttackLogic` | `onAttackClient` | `self, attacker, mob, damages` | client | 1-4 |
| `PlayerAttackLogic` | `onDamageByMob` | `self, attacker, mob, skillID, skillLevel, totalDelay, counter, damages` | server-only | 1-96 |
| `PlayerAttackLogic` | `onDamageByMobWithDamages` | `self, attacker, mob, damages, criticals, damageDelay, showDamage` | server-only | 1-75 |
| `PlayerAttackLogic` | `onDeadlyAttack` | `self, mob, delay` | server-only | 1-6 |
| `PlayerAttackLogic` | `onPlayerAttack` | `self, attacker, sad, senderUserId` | server-only | 1-299 |
| `PlayerAttackLogic` | `overrideComboTempestDamages` | `self, mob, damages, criticals` | client | 1-31 |
| `PlayerAttackLogic` | `overrideSanctuaryDamages` | `self, mob, damages, criticals` | client | 1-24 |
| `PlayerAttackLogic` | `playSkillEffect` | `self, attacker, skillID, effectIndex, specialData, playRate, forceBackLayer` | client | 1-39 |
| `PlayerAttackLogic` | `receiveAttackInfoClient` | `self, attackInfo` | client | 1-96 |
| `PlayerAttackLogic` | `recordSkillActionLog` | `self, attacker, sad, totalDamage` | client | 1-38 |
| `PlayerAttackLogic` | `refreshSummonAttackAbleTimeClient` | `self, attacker` | client | 1-18 |
| `PlayerAttackLogic` | `reserveAranComboGainOnFirstHit` | `self, attacker, skillID, totalDamage, mobCount, attackCount, firstHitDelay` | server-only | 1-27 |
| `PlayerAttackLogic` | `resetPendingHiddenAttackBoost` | `self, attacker` | client | 1-8 |
| `PlayerAttackLogic` | `setSkillMotion` | `self, attacker, skillData, skillID, skillLevel, weaponInfo, isFinalAttack, isShoot, remote` | client | 1-123 |
| `PlayerAttackLogic` | `setUserAttackLogWatcher` | `self, watcherUserId, targetProfileCode, targetName` | server-only | 1-11 |
| `PlayerAttackLogic` | `shouldCheckAttackSkillCooldown` | `self, skillID, skillData, skillLevelData` | client | 1-18 |
| `PlayerAttackLogic` | `shouldDisplayDamageByAttacker` | `self, attacker` | client | 1-7 |
| `PlayerAttackLogic` | `shouldEnforceHitCountByJob` | `self, attacker` | server-only | 1-18 |
| `PlayerAttackLogic` | `shouldLogAttackSkillUse` | `self, skillID` | client | 1-12 |
| `PlayerAttackLogic` | `shouldLogSkillActionLockEarly` | `self, pv, now, remain, serverDelay, clientDelay` | client | 1-25 |
| `PlayerAttackLogic` | `shouldSkipSkillActionLockServerCheck` | `self, sad` | client | 1-18 |
| `PlayerAttackLogic` | `shouldSkipSkillLtRbUnionBoxCheck` | `self, sad, targetIndex` | server-only | 1-9 |
| `PlayerAttackLogic` | `shouldUseClientHitCount` | `self, attackType` | client | 1-5 |
| `PlayerAttackLogic` | `truncateAttackHitsServer` | `self, targetData, hitLimit` | server-only | 1-8 |
| `PlayerAttackLogic` | `tryApplyAllPotentialOnHit` | `self, attacker, mob` | server-only | 1-34 |
| `PlayerAttackLogic` | `tryApplyPotentialAutoStealOnHit` | `self, attacker, mob` | server-only | 1-35 |
| `PlayerAttackLogic` | `tryApplyPotentialDarknessOnHit` | `self, attacker, mob` | server-only | 1-34 |
| `PlayerAttackLogic` | `tryApplyPotentialFreezeOnHit` | `self, attacker, mob` | server-only | 1-30 |
| `PlayerAttackLogic` | `tryApplyPotentialPoisonOnHit` | `self, attacker, mob` | server-only | 1-33 |
| `PlayerAttackLogic` | `tryApplyPotentialRecoverOnHit` | `self, attacker` | server-only | 1-32 |
| `PlayerAttackLogic` | `tryApplyPotentialRecoverOnKill` | `self, user` | server-only | 1-32 |
| `PlayerAttackLogic` | `tryApplyPotentialSealOnHit` | `self, attacker, mob` | server-only | 1-30 |
| `PlayerAttackLogic` | `tryApplyPotentialSlowOnHit` | `self, attacker, mob` | server-only | 1-31 |
| `PlayerAttackLogic` | `tryApplyPotentialStunOnHit` | `self, attacker, mob` | server-only | 1-30 |
| `PlayerAttackLogic` | `tryApplyUnidentifiedPotentialDropByMob` | `self, mob, equip` | server-only | 1-50 |
| `PlayerAttackLogic` | `tryMobKnockback` | `self, attacker, mob, skillID, skillLevel, totalDelay, totalDamage, deadlyAttack, highestDamage, isMelee, weaponInfo, attackerPosSnapshot, mobPosSnapshot, hitIndex, playerInputX` | server-only | 1-201 |
| `PlayerAttackLogic` | `tryPlayerAttack` | `self, attacker, skillID, skillLevel, isMeleeAttack, chargePer, forceTarget` | client | 1-182 |
| `PlayerAttackLogic` | `trySparkChainAttack` | `self, attacker, sourceSkillID, sourceMobs, baseDelayMs` | client | 1-151 |
| `PlayerAttackLogic` | `validateSkillActionLockServer` | `self, attacker, sad, now` | client | 1-48 |
| `PlayerAttackLogic_FinalAttack` | `getFinalAttackIDListBySkillID` | `self, skillID` | client | 1-10 |
| `PlayerAttackLogic_FinalAttack` | `tryRegisterFinalAttack` | `self, player, attackSkillID, attackSkillLevel, weaponType, delay` | client | 1-42 |
| `PlayerAttackLogic_Magic` | `getChainLineBallState` | `self, skillID, index` | client | 1-9 |
| `PlayerAttackLogic_Magic` | `getMakeFootholdEffectDelay` | `self, pa, ctx, defaultDelay` | client | 1-15 |
| `PlayerAttackLogic_Magic` | `getMeteorHitIndex` | `self, ctx` | client | 1-17 |
| `PlayerAttackLogic_Magic` | `getMeteorSelectedHitData` | `self, ctx, hitIndex` | client | 1-6 |
| `PlayerAttackLogic_Magic` | `getMeteorTargetMobs` | `self, attacker, ctx, targets` | client | 1-8 |
| `PlayerAttackLogic_Magic` | `isChainLightningLikeSkill` | `self, skillID` | client | 1-3 |
| `PlayerAttackLogic_Magic` | `isFootholdMeteorSkill` | `self, skillID` | client | 1-6 |
| `PlayerAttackLogic_Magic` | `onAttack_ChainLightning` | `self, attacker, attackDelay, ctx, hitDelayInfo, actionLockDelay` | client | 1-152 |
| `PlayerAttackLogic_Magic` | `onAttack_Explosion` | `self, attacker, ctx, motion, chargePer` | client | 1-49 |
| `PlayerAttackLogic_Magic` | `onAttack_MeteorShower` | `self, attacker, ctx, actionDelay, chargePer, actionLockDelay` | client | 1-115 |
| `PlayerAttackLogic_Magic` | `playEffect` | `self, attacker, ctx, totalDelay, weaponType` | client | 1-15 |
| `PlayerAttackLogic_Magic` | `playMeteorMobHitEffectClient` | `self, attacker, ctx, mob, hitIndex` | client | 1-31 |
| `PlayerAttackLogic_Magic` | `spawnChainLineTo` | `self, startPos, targetPos, step, countPerBatch, batchDelay, angleOverride, ownerEntity, skillID` | client | 1-74 |
| `PlayerAttackLogic_Magic` | `tryMagicAttack` | `self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer` | client | 1-97 |
| `PlayerAttackLogic_Melee` | `calculateHitBox` | `self, attacker, ctx, isFaceLeft` | client | 1-47 |
| `PlayerAttackLogic_Melee` | `findPartyMembersByHeal` | `self, player, skillData, skillLevelData` | client | 1-18 |
| `PlayerAttackLogic_Melee` | `getRangeDelay` | `self, skillID` | client | 1-25 |
| `PlayerAttackLogic_Melee` | `initSkillAttackData` | `self, skillID, skillLevel, playerPos, playerInputX, targets, hits, motion, attackType, mobs, damages, criticals, delays, firstAttackDelay, playRate, isFaceLeft, finalAttackSkillID, starItemID, range, targetCount, bulletSlot, chainLightningInfo, chargePer, finishAttack, mesoExplosionInfo` | client | 1-74 |
| `PlayerAttackLogic_Melee` | `initSkillCtx` | `self, attacker, skillID, skillLevel, weaponInfo, isFinalAttack, isShoot, remote` | client | 1-54 |
| `PlayerAttackLogic_Melee` | `isCanAttack` | `self, attacker, weaponInfo, ctx` | client | 1-50 |
| `PlayerAttackLogic_Melee` | `isDelayRangeAttackSkill` | `self, skillID` | client | 1-10 |
| `PlayerAttackLogic_Melee` | `isNotPlayAfterimageSkill` | `self, skillID` | client | 1-8 |
| `PlayerAttackLogic_Melee` | `isNotRecalcRectByAfterimage` | `self, skillID` | client | 1-10 |
| `PlayerAttackLogic_Melee` | `onAttack` | `self, attacker, ctx, hitDelayInfo, totalDelay, finalAttackSkillID, bulletSlot, chargePer, isFinishAttack, lastAttackMobs, forceTarget, actionLockDelay` | client | 1-505 |
| `PlayerAttackLogic_Melee` | `onFirstAttackClient` | `self, attacker, ctx, mobs` | client | 1-22 |
| `PlayerAttackLogic_Melee` | `playAttackSound` | `self, attacker, target, skillID, targetMobID` | client | 1-16 |
| `PlayerAttackLogic_Melee` | `playComboTempestBackgroundEffect` | `self, attacker` | client | 1-65 |
| `PlayerAttackLogic_Melee` | `playEffect` | `self, attacker, ctx, totalDelay, hitDelayInfo, isFinalAttack` | client | 1-80 |
| `PlayerAttackLogic_Melee` | `playFallingAnimationOnCast` | `self, attacker, ctx, mobs` | client | 1-22 |
| `PlayerAttackLogic_Melee` | `resolveAfterimageData` | `self, attacker, ctx` | client | 1-86 |
| `PlayerAttackLogic_Melee` | `resolveHitEffectData` | `self, attacker, skillData` | client | 1-34 |
| `PlayerAttackLogic_Melee` | `shouldPlayAttackSound` | `self, attacker` | client | 1-7 |
| `PlayerAttackLogic_Melee` | `tryMeleeAttack` | `self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer, forceMotion, isFinishAttack, lastAttackMobs, forceTarget` | client | 1-321 |
| `PlayerAttackLogic_Shoot` | `afterAttack` | `self, attacker, skillID, skillLevel, totalDamage, mobCount, attackCount` | server-only | 1-134 |
| `PlayerAttackLogic_Shoot` | `afterAttackMob` | `self, attacker, mob, skillID, skillLevel, totalDamage, deadlyAttack, delay` | server-only | 1-296 |
| `PlayerAttackLogic_Shoot` | `calcPoisonTickDamage` | `self, mobMaxHP, skillLevel` | client | 1-5 |
| `PlayerAttackLogic_Shoot` | `canIgnoreStartFootholdBlockSkill` | `self, skillID` | client | 1-17 |
| `PlayerAttackLogic_Shoot` | `canShootAttack` | `self, attacker, skillID` | client | 1-16 |
| `PlayerAttackLogic_Shoot` | `checkUseConsumeClient` | `self, player, skillID, skillLevelData, bulletItemID, bulletCount, consumeBulletCount` | client | 1-172 |
| `PlayerAttackLogic_Shoot` | `checkWall` | `self, map, skillID, startPos, targetPos, isMagic` | client | 1-26 |
| `PlayerAttackLogic_Shoot` | `createBulletClient` | `self, map, attacker, mobs, bulletCount, bulletDelay, shootDelay, startPos, bullet, weaponType, isFaceLeft, isMagic, passThrough, boxShape, range, soulArrowSkillID, ctx` | client | 1-413 |
| `PlayerAttackLogic_Shoot` | `createGrenadeClient` | `self, map, attacker, skillID, skillLevel, startPos, chargeTime, isFaceLeft` | client | 1-36 |
| `PlayerAttackLogic_Shoot` | `filterOnlyLiveMobs` | `self, hit, temp, output, attacker` | client | 1-71 |
| `PlayerAttackLogic_Shoot` | `findHitMobInTrapezoid` | `self, x0, x1, x2, y, r, output, left, finalBoxShape, entity, targetMob` | client | 1-113 |
| `PlayerAttackLogic_Shoot` | `findHitMobInTrapezoidRect` | `self, x0, x1, x2, y, adjustVerticalRange, r, output, left, finalBoxShape, entity, targetMob, useRect` | client | 1-113 |
| `PlayerAttackLogic_Shoot` | `getAranSwingMasterySkillID` | `self, skillID` | client | 1-12 |
| `PlayerAttackLogic_Shoot` | `getBulletDelay` | `self, bulletItemId, skillId, def` | client | 1-13 |
| `PlayerAttackLogic_Shoot` | `getBulletSpeedBySkill` | `self, skillID` | client | 1-9 |
| `PlayerAttackLogic_Shoot` | `getHitPointByBox` | `self, mob, box` | client | 1-8 |
| `PlayerAttackLogic_Shoot` | `getShootDelay` | `self, skillId, def` | client | 1-40 |
| `PlayerAttackLogic_Shoot` | `getShootSkillRange` | `self, player, skillId, weaponType` | client | 1-60 |
| `PlayerAttackLogic_Shoot` | `getShootStartRange` | `self, skillID` | client | 1-20 |
| `PlayerAttackLogic_Shoot` | `getTriggerBoxFromLtRb` | `self, lt, rb, left` | client | 1-19 |
| `PlayerAttackLogic_Shoot` | `handlePickpocket` | `self, attacker, mob, damages` | server-only | 1-30 |
| `PlayerAttackLogic_Shoot` | `intersectBox` | `self, b1, b2` | client | 1-32 |
| `PlayerAttackLogic_Shoot` | `isNotMeleeAttackByNearMob` | `self, skillID` | client | 1-12 |
| `PlayerAttackLogic_Shoot` | `isPassThroughSkill` | `self, skillId` | client | 1-24 |
| `PlayerAttackLogic_Shoot` | `isStraightPassThroughSkill` | `self, skillId` | client | 1-6 |
| `PlayerAttackLogic_Shoot` | `makeBoxShape` | `self, origin, anchor, size, left` | client | 1-8 |
| `PlayerAttackLogic_Shoot` | `makeBoxShapeFromLtRb` | `self, origin, lt, rb, left` | client | 1-4 |
| `PlayerAttackLogic_Shoot` | `onAttack` | `self, attacker, itemId, bulletCount, totalActionDelay, skillID, skillLevel, weaponType, attackMotion, hitDelayInfo, ctx, isMagic, bulletSlot, chargePer, forceTarget, actionLockDelay` | client | 1-317 |
| `PlayerAttackLogic_Shoot` | `onUseConsume` | `self, player, skillID, skillLevelData, attackType, isMagic` | server-only | 1-173 |
| `PlayerAttackLogic_Shoot` | `playEffect` | `self, attacker, ctx, totalDelay, weaponType` | client | 1-23 |
| `PlayerAttackLogic_Shoot` | `playMpEaterEffectClient` | `self, attacker, mpEaterSkillID` | client | 1-6 |
| `PlayerAttackLogic_Shoot` | `setSkillMotion` | `self` | server-only | 1-3 |
| `PlayerAttackLogic_Shoot` | `triggerToBox` | `self, t` | client | 1-3 |
| `PlayerAttackLogic_Shoot` | `tryShootAttack` | `self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer, isMagic, forceTarget` | client | 1-284 |
| `PlayerAttackLogic_Shoot` | `tryUseConsume` | `self, player, skillID, attackType, isMagic, senderUserId` | server-only | 1-38 |
| `PlayerAvatarLookLogic` | `getAvatarItemCategory` | `self, itemID` | client | 1-56 |
| `PlayerAvatarLookLogic` | `updateLook` | `self, costume, gender, hair, face, skin, equipment, useMSWCody, userID, blockMSWCody` | client | 1-136 |
| `PlayerAvatarLookLogic` | `updatePlayerLook` | `self, user, useMSWCody, blockMSWCody` | client | 1-20 |
| `PlayerConstants` | `getBOFSkillID` | `self, jobID` | client | 1-15 |
| `PlayerConstants` | `getDefaultAnchor` | `self, leftFacing` | client | 1-3 |
| `PlayerConstants` | `getJobNameById` | `self, job` | client | 1-81 |
| `PlayerConstants` | `getMaxEXP` | `self, level` | client | 1-3 |
| `PlayerConstants` | `getMaxEXPByJob` | `self, level, job` | client | 1-7 |
| `PlayerConstants` | `getMaxLevelByJob` | `self, job` | client | 1-6 |
| `PlayerConstants` | `getNobleMindSkillID` | `self, jobID` | client | 1-15 |
| `PlayerConstants` | `isCygnusJob` | `self, job` | client | 1-4 |
| `PlayerConstants` | `isDualBlade` | `self, job` | client | 1-3 |
| `PlayerConstants` | `OnBeginPlay` | `self` | client | 1-24 |
| `PlayerDataLogic` | `clearAutoSaveTimer` | `self, user` | server-only | 1-13 |
| `PlayerDataLogic` | `deinitPlayer` | `self, user` | server-only | 1-33 |
| `PlayerDataLogic` | `getPlayerData` | `self, user, playerId` | server-only | 1-83 |
| `PlayerDataLogic` | `HandleUserReconnectEvent` | `self, event` | client | 1-39 |
| `PlayerDataLogic` | `initializeDailyGiftQuestEx` | `self, user` | server-only | 1-15 |
| `PlayerDataLogic` | `initPlayer` | `self, userId, playerId, isWarpLogin` | server-only | 1-476 |
| `PlayerDataLogic` | `initPlayerFromClient` | `self, index, senderUserId` | server-only | 1-79 |
| `PlayerDataLogic` | `initPlayerToClient` | `self, loadedName, restoredTemporaryStatUIDatas, forceDesktopObserver` | client | 1-121 |
| `PlayerDataLogic` | `markSaveProcess` | `self, user, processing` | server-only | 1-5 |
| `PlayerDataLogic` | `onInitPlayerFromClientByPlayerId` | `self, playerId, userId` | server-only | 1-71 |
| `PlayerDataLogic` | `onLeavePlayer` | `self, userId` | server-only | 1-277 |
| `PlayerDataLogic` | `requestAddBlackList` | `self, targetName, dateText, senderUserId` | server-only | 1-18 |
| `PlayerDataLogic` | `requestRemoveBlackList` | `self, targetName, senderUserId` | server-only | 1-19 |
| `PlayerDataLogic` | `resetClient` | `self` | client | 1-245 |
| `PlayerDataLogic` | `resetServer` | `self, user` | server-only | 1-62 |
| `PlayerDataLogic` | `returnToTitleFromClient` | `self, senderUserId` | server-only | 1-4 |
| `PlayerDataLogic` | `savePlayerDataWithProcess` | `self, user, playerId, saveData, reason` | server-only | 1-19 |
| `PlayerDataLogic` | `setAutoSaveTimer` | `self, user, timer` | server-only | 1-14 |
| `PlayerDataLogic` | `successWarpLogin` | `self` | client | 1-13 |
| `PlayerDataLogic` | `syncSkillCooltimesClient` | `self, restoredSkillCooltimes` | client | 1-18 |
| `PlayerDataLogic` | `tryInitPlayerFromClientByPlayerId` | `self, senderUserId` | server-only | 1-14 |
| `PlayerDataLogic` | `tryReturnToTitle` | `self, userId` | server-only | 1-29 |
| `PlayerKeyActionFunction` | `loadKeyAction` | `self` | client | 1-49 |
| `PlayerKeyActionFunction` | `onAbility` | `self` | client | 1-7 |
| `PlayerKeyActionFunction` | `onAttack` | `self` | client | 1-30 |
| `PlayerKeyActionFunction` | `onCashshop` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onChat` | `self` | client | 1-7 |
| `PlayerKeyActionFunction` | `onChatNPC` | `self` | client | 1-65 |
| `PlayerKeyActionFunction` | `onChatPlus` | `self` | client | 1-21 |
| `PlayerKeyActionFunction` | `onDps` | `self` | client | 1-24 |
| `PlayerKeyActionFunction` | `onEmotion` | `self, type` | client | 1-4 |
| `PlayerKeyActionFunction` | `onEquip` | `self` | client | 1-7 |
| `PlayerKeyActionFunction` | `onExpedition` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onFindParty` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onFriend` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onGuild` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onInventory` | `self` | client | 1-7 |
| `PlayerKeyActionFunction` | `onJump` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onKeyconfig` | `self` | client | 1-4 |
| `PlayerKeyActionFunction` | `onLoot` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onMedal` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onMenu` | `self, byEsc` | client | 1-84 |
| `PlayerKeyActionFunction` | `onMessenger` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onMinimap` | `self` | client | 1-25 |
| `PlayerKeyActionFunction` | `onMobileChatNPC` | `self` | client | 1-64 |
| `PlayerKeyActionFunction` | `onMonsterbook` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onNotification` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onParty` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onQuest` | `self` | client | 1-4 |
| `PlayerKeyActionFunction` | `onQuickslot` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onShortCut` | `self` | client | 1-63 |
| `PlayerKeyActionFunction` | `onSit` | `self` | client | 1-49 |
| `PlayerKeyActionFunction` | `onSkill` | `self` | client | 1-11 |
| `PlayerKeyActionFunction` | `onToAll` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onToAlliance` | `self` | server-only | 1-3 |
| `PlayerKeyActionFunction` | `onToChannel` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onToFriend` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onToGuild` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onToParty` | `self` | client | 1-3 |
| `PlayerKeyActionFunction` | `onWhisper` | `self` | client | 1-6 |
| `PlayerKeyActionFunction` | `onWorldmap` | `self` | client | 1-25 |
| `PlayerSkillLogic` | `afterResetTemporaryStat` | `self, player, skillID` | server-only | 1-33 |
| `PlayerSkillLogic` | `afterResetTemporaryStatByFlag` | `self, player, skillID, flagIndex, value` | server-only | 1-38 |
| `PlayerSkillLogic` | `afterResetTemporaryStatByFlagClient` | `self, player, skillID, flagIndex` | client | 1-40 |
| `PlayerSkillLogic` | `afterResetTemporaryStatClient` | `self, player, skillID` | client | 1-56 |
| `PlayerSkillLogic` | `afterSetTemporaryStat` | `self, player, skillID` | server-only | 1-43 |
| `PlayerSkillLogic` | `afterSetTemporaryStatByFlagClient` | `self, player, skillID, flagIndex, value` | client | 1-24 |
| `PlayerSkillLogic` | `afterSetTemporaryStatClient` | `self, player, skillID` | client | 1-70 |
| `PlayerSkillLogic` | `appendEffectEntityClientWithRenderSkillID` | `self, player, data, storageSkillID, renderSkillID` | client | 1-3 |
| `PlayerSkillLogic` | `appendEffectEntityClientWithRenderSkillIDAndKey` | `self, player, data, storageSkillID, renderSkillID, keyName` | client | 1-33 |
| `PlayerSkillLogic` | `appendEffectEntityWithRenderSkillID` | `self, player, data, storageSkillID, renderSkillID, senderUserId` | server-only | 1-3 |
| `PlayerSkillLogic` | `appendEffectEntityWithRenderSkillIDAndKey` | `self, player, data, storageSkillID, renderSkillID, keyName, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `appendEffectWithRenderSkillID` | `self, player, storageSkillID, renderSkillID, data` | client | 1-3 |
| `PlayerSkillLogic` | `appendEffectWithRenderSkillIDAndKey` | `self, player, storageSkillID, renderSkillID, data, keyName` | client | 1-6 |
| `PlayerSkillLogic` | `appendTrackedLoopEffectForState` | `self, state, fieldName, player, skillID, data` | client | 1-23 |
| `PlayerSkillLogic` | `applyBattleshipDismountAttackDelay` | `self, player, skillID` | client | 1-12 |
| `PlayerSkillLogic` | `applyResetAllSkillCooldowns` | `self, player, exceptSkillID` | client | 1-23 |
| `PlayerSkillLogic` | `applySkillLevelDataCooldown` | `self, player, skillID, skillLevelData, currentTime` | client | 1-12 |
| `PlayerSkillLogic` | `applySpecialLoopEffectPlacement` | `self, storageSkillID, ret` | client | 1-17 |
| `PlayerSkillLogic` | `applySwimFlyPoseForHurricane` | `self, player` | client | 1-7 |
| `PlayerSkillLogic` | `applyTamingMobSecondaryTemporaryStats` | `self, player, ctsData, tamingMobId` | client | 1-18 |
| `PlayerSkillLogic` | `calculateFlashJumpForce` | `self, velocityY, level` | client | 1-32 |
| `PlayerSkillLogic` | `cancelActiveKeyDownForNotice` | `self, player` | client | 1-26 |
| `PlayerSkillLogic` | `canStartHurricanePrepare` | `self, player, currentTime` | client | 1-5 |
| `PlayerSkillLogic` | `canUseBuffSkillByWeaponSilent` | `self, skillID, weaponInfo` | client | 1-39 |
| `PlayerSkillLogic` | `canUseHurricaneArrow` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `canUseMonsterRiderSkill` | `self, player` | client | 1-8 |
| `PlayerSkillLogic` | `canUseSkillOnBattleship` | `self, skillID` | client | 1-14 |
| `PlayerSkillLogic` | `checkCanUseSkillByWeapon` | `self, skillID, weaponInfo` | client | 1-157 |
| `PlayerSkillLogic` | `checkHurricaneConsumeClient` | `self, player, skillID, skillLevelData, currentTime` | client | 1-11 |
| `PlayerSkillLogic` | `checkHurricaneLikeUseConsumeClient` | `self, player, skillID, skillLevelData, currentTime` | client | 1-3 |
| `PlayerSkillLogic` | `checkPrepare` | `self, player, skillID, skillLevel, skillData` | client | 1-114 |
| `PlayerSkillLogic` | `clearAssassinateFollowUpTimer` | `self, state` | client | 1-7 |
| `PlayerSkillLogic` | `clearHurricaneAttackLoop` | `self, state` | client | 1-7 |
| `PlayerSkillLogic` | `clearHurricaneKeydownEffects` | `self, player, skillID` | client | 1-11 |
| `PlayerSkillLogic` | `clearInactiveHurricaneEffects` | `self, player, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `clearPiercingKeydownVisualEffects` | `self, player, skillID, skillData` | client | 1-8 |
| `PlayerSkillLogic` | `clearPlayerRuntimeState` | `self, player` | server-only | 1-35 |
| `PlayerSkillLogic` | `clearSkillCooldownEndTime` | `self, player, skillID` | client | 1-11 |
| `PlayerSkillLogic` | `clearSkillCooldownEndTimeClient` | `self, player, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `clearStaleProneStateBeforeAttackSkill` | `self, player, pa, isDownArrowPressed` | client | 1-27 |
| `PlayerSkillLogic` | `clearTamingMobEntering` | `self` | client | 1-5 |
| `PlayerSkillLogic` | `doActiveSkill_Summon` | `self, user, skillID` | client | 1-66 |
| `PlayerSkillLogic` | `doActiveSkill_TownPortal` | `self, user` | client | 1-33 |
| `PlayerSkillLogic` | `doUseSkill` | `self, caster, player, skillID, skillLevel, skillData, skillLevelData, fromPartyBuff, totalTargetOnlyPlayer, ctx` | server-only | 1-273 |
| `PlayerSkillLogic` | `doUseSkillByMob` | `self, player, mob, skillID, skillLevel, skillData, skillLevelData` | server-only | 1-164 |
| `PlayerSkillLogic` | `endActiveKeyDownForUtilDlg` | `self, player` | client | 1-23 |
| `PlayerSkillLogic` | `endWings` | `self, player, skillID` | client | 1-25 |
| `PlayerSkillLogic` | `ensureHurricaneAttackLoop` | `self, player, skillID, skillData` | client | 1-42 |
| `PlayerSkillLogic` | `findMobTargetsFromHitBoxClient` | `self, player, ctx, skillLevelData` | client | 1-21 |
| `PlayerSkillLogic` | `finishHurricaneKeydown` | `self, player, skillID, skillData, playKeydownEnd` | client | 1-36 |
| `PlayerSkillLogic` | `finishKeydownControlledAction` | `self, player` | client | 1-8 |
| `PlayerSkillLogic` | `finishPiercingKeydown` | `self, player, skillID, skillData, playKeydownEnd` | client | 1-22 |
| `PlayerSkillLogic` | `forceCleanupRegularKeydownEffect` | `self, player, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `forceCleanupRegularKeydownEffectDeferred` | `self, player, skillID` | client | 1-9 |
| `PlayerSkillLogic` | `freezeHurricanePreparePose` | `self, player, skillData` | client | 1-19 |
| `PlayerSkillLogic` | `getActiveHiddenKeydownSkillID` | `self, player` | client | 1-9 |
| `PlayerSkillLogic` | `getAssassinateFollowUpDelaySec` | `self, player, skillID` | client | 1-10 |
| `PlayerSkillLogic` | `getAssassinateFollowUpTargetPos` | `self, player` | client | 1-78 |
| `PlayerSkillLogic` | `getAssassinateState` | `self, player` | client | 1-13 |
| `PlayerSkillLogic` | `getBattleshipReuseDelaySec` | `self` | client | 1-3 |
| `PlayerSkillLogic` | `getCanUseSkillTime` | `self, player, skillID` | client | 1-8 |
| `PlayerSkillLogic` | `getCorkscrewKeydownStorageSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getDoubleJumpSkillList` | `self` | client | 1-8 |
| `PlayerSkillLogic` | `getDuration` | `self, player, skillID, duration` | client | 1-11 |
| `PlayerSkillLogic` | `getHurricaneKeydownEndRemoteEffectSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getHurricanePrepareRemoteEffectSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getHurricaneState` | `self, player` | client | 1-13 |
| `PlayerSkillLogic` | `getPiercingKeydownEndRemoteEffectSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getPiercingPrepareRemoteEffectSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getPiercingState` | `self, player` | client | 1-13 |
| `PlayerSkillLogic` | `getPlayerRuntimeStateKey` | `self, player` | client | 1-6 |
| `PlayerSkillLogic` | `getProneNormalAttackReason` | `self, player, pa, isDownArrowPressed, isJumpPressed, isLeftPressed, isRightPressed` | client | 1-50 |
| `PlayerSkillLogic` | `getRapidFireKeydown0StorageSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `getSkillActionLockDelaySec` | `self, player, skillID, motion, fallbackDelay, extraDelay` | client | 1-12 |
| `PlayerSkillLogic` | `getSkillActionLockDelaySecByAttackSpeed` | `self, skillID, motion, fallbackDelay, extraDelay, attackSpeed` | client | 1-24 |
| `PlayerSkillLogic` | `getSkillCooldownEndTime` | `self, player, skillID` | client | 1-8 |
| `PlayerSkillLogic` | `getSkillLevelDataCooltimeSec` | `self, skillLevelData, skillID` | client | 1-16 |
| `PlayerSkillLogic` | `getSkillMinActionLockDelaySec` | `self, skillID, motion, fallbackDelay, extraDelay` | client | 1-4 |
| `PlayerSkillLogic` | `getSkillSoundRefId` | `self, skillID` | client | 1-16 |
| `PlayerSkillLogic` | `getTamingMobIDFromSkillID` | `self, skillID, player` | client | 1-40 |
| `PlayerSkillLogic` | `handleHurricaneArrowExhausted` | `self, player, skillID` | client | 1-14 |
| `PlayerSkillLogic` | `hasForcedBattleshipCooldown` | `self, player, skillID, currentTime` | client | 1-7 |
| `PlayerSkillLogic` | `interruptHurricaneLikeSkillsByAbnormalStatus` | `self, player` | client | 1-3 |
| `PlayerSkillLogic` | `interruptHurricaneSkillsByAbnormalStatus` | `self, player` | client | 1-17 |
| `PlayerSkillLogic` | `isAmplificationSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isAssassinateFollowUpActive` | `self, player` | client | 1-4 |
| `PlayerSkillLogic` | `isAttackSkill` | `self, skillID` | client | 1-11 |
| `PlayerSkillLogic` | `isBattleshipMounted` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `isBattleshipMountOnlySkill` | `self, skillID` | client | 1-4 |
| `PlayerSkillLogic` | `isBattleshipSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isBigBangSkill` | `self, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `isBooster` | `self, skillID` | client | 1-29 |
| `PlayerSkillLogic` | `isBuffSkill` | `self, skillID` | client | 1-21 |
| `PlayerSkillLogic` | `isCorkscrewSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isDarkSightLikeSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isDarkSightSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isDisorder` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isDoubleJumpSkill` | `self, skillID` | client | 1-8 |
| `PlayerSkillLogic` | `isEchoOfHeroSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isFieldLimitBlockedTamingMobSkill` | `self, skillID, player` | client | 1-9 |
| `PlayerSkillLogic` | `isFlameGearPlacementBlocked` | `self, player, skillID, skillLevelData` | client | 1-38 |
| `PlayerSkillLogic` | `isFootholdMeteorActionLockSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isHaste` | `self, skillID` | client | 1-10 |
| `PlayerSkillLogic` | `isHerosWill` | `self, skillID` | client | 1-17 |
| `PlayerSkillLogic` | `isHurricaneActive` | `self, player, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isHurricaneLikeSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isHurricaneSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isHurricaneSkillGroup` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isItemEnchantSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isJobRidingSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isMapleWarriorSkill` | `self, skillID` | client | 1-18 |
| `PlayerSkillLogic` | `isMobUnionBoxInSkillBox` | `self, mob, skillBox` | server-only | 1-26 |
| `PlayerSkillLogic` | `isMonsterMagnetSkill` | `self, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `isMonsterRiderSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isMorphCancelable` | `self, player` | client | 1-11 |
| `PlayerSkillLogic` | `isMysticDoorSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isNeedBypassMadSkill` | `self, skillID` | client | 1-13 |
| `PlayerSkillLogic` | `isNeedSkipMadSkill` | `self, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `isNeedSkipPadSkill` | `self, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `isNeedSkipPddMddSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isNinjaAmbushSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isPassiveSkill` | `self, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isPiercingActive` | `self, player, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isPiercingPrepareRemoteEffectSkillID` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isPiercingSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isRangeMobDebuffSkill` | `self, skillID` | client | 1-15 |
| `PlayerSkillLogic` | `isRapidFireSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isSealSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isShouldRemovePadSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isShouldRemovePddMddSkill` | `self, skillID` | client | 1-64 |
| `PlayerSkillLogic` | `isSkillRidingTamingMobSkill` | `self, skillID, player` | client | 1-3 |
| `PlayerSkillLogic` | `isSummonSkill` | `self, skillID` | client | 1-6 |
| `PlayerSkillLogic` | `isSwimAirborneForHurricane` | `self, player` | client | 1-14 |
| `PlayerSkillLogic` | `isTamingMobBlockedMorph` | `self, morphId` | client | 1-6 |
| `PlayerSkillLogic` | `isTamingMobEnteringWindow` | `self` | client | 1-14 |
| `PlayerSkillLogic` | `isTamingMobSkill` | `self, skillID, player` | client | 1-3 |
| `PlayerSkillLogic` | `isUnableToUseSkillFieldLimitTargetSkill` | `self, skillID` | client | 1-9 |
| `PlayerSkillLogic` | `isUsefulHasteSkill` | `self, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isUsefulHyperBodySkill` | `self, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isUsefulMysticDoorSkill` | `self, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isUsefulSharpEyesSkill` | `self, skillID` | client | 1-7 |
| `PlayerSkillLogic` | `isWindArcherMorphAttackSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isWindBooster` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `isWindWalkSkill` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `logSkillActionLockClient` | `self, player, source, skillID, motion, actionLockDelay, firstAttackDelay, totalActionDelay` | client | 1-10 |
| `PlayerSkillLogic` | `markHurricanePrepareCooldown` | `self, player, currentTime` | client | 1-4 |
| `PlayerSkillLogic` | `markTamingMobEntering` | `self` | client | 1-8 |
| `PlayerSkillLogic` | `onChangeMap` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `onDoubleClickSameDirectionKey` | `self, player, inputDirX` | client | 1-17 |
| `PlayerSkillLogic` | `onGround` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `onJump` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `onKeyDown` | `self, player, fromDoubleClick, endKeyDown, skillData, skillLevelData, skillID` | client | 1-87 |
| `PlayerSkillLogic` | `onMesoExplosion` | `self, player, explodeList` | server-only | 1-11 |
| `PlayerSkillLogic` | `playAffectedEffect` | `self, player, skillID` | client | 1-8 |
| `PlayerSkillLogic` | `playAlertAction` | `self, player` | client | 1-8 |
| `PlayerSkillLogic` | `playAndSetEffectEntity` | `self, player, data, skillID, senderUserId` | server-only | 1-3 |
| `PlayerSkillLogic` | `playAndsetEffectEntityClient` | `self, player, data, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `playAndsetEffectEntityClientWithRenderSkillID` | `self, player, data, storageSkillID, renderSkillID` | client | 1-3 |
| `PlayerSkillLogic` | `playAndsetEffectEntityClientWithRenderSkillIDAndKey` | `self, player, data, storageSkillID, renderSkillID, keyName` | client | 1-21 |
| `PlayerSkillLogic` | `playAndSetEffectEntityWithRenderSkillID` | `self, player, data, storageSkillID, renderSkillID, senderUserId` | server-only | 1-3 |
| `PlayerSkillLogic` | `playAndSetEffectEntityWithRenderSkillIDAndKey` | `self, player, data, storageSkillID, renderSkillID, keyName, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `playAssassinateFollowUpVisual` | `self, player, skillID` | client | 1-10 |
| `PlayerSkillLogic` | `playEffect` | `self, player, skillID, data` | client | 1-17 |
| `PlayerSkillLogic` | `playEffectWithRenderSkillID` | `self, player, storageSkillID, renderSkillID, data` | client | 1-3 |
| `PlayerSkillLogic` | `playEffectWithRenderSkillIDAndKey` | `self, player, storageSkillID, renderSkillID, data, keyName` | client | 1-8 |
| `PlayerSkillLogic` | `playHurricaneKeydownEndEffectRemote` | `self, player, skillID, data` | client | 1-12 |
| `PlayerSkillLogic` | `playHurricanePrepareEffectRemote` | `self, player, skillID, data` | client | 1-8 |
| `PlayerSkillLogic` | `playOneShotEffect` | `self, player, skillID, data` | client | 1-5 |
| `PlayerSkillLogic` | `playPiercingKeydownEndEffectRemote` | `self, player, skillID, data` | client | 1-12 |
| `PlayerSkillLogic` | `playPiercingPrepareEffectRemote` | `self, player, skillID, data` | client | 1-8 |
| `PlayerSkillLogic` | `playTamingMobMountSoundClient` | `self, player` | client | 1-5 |
| `PlayerSkillLogic` | `playTrackedLoopEffectForState` | `self, state, fieldName, player, skillID, data` | client | 1-8 |
| `PlayerSkillLogic` | `playTrackedPrepareEffect` | `self, player, skillID, data` | client | 1-9 |
| `PlayerSkillLogic` | `playTrackedPrepareEffectForState` | `self, state, player, skillID, data` | client | 1-21 |
| `PlayerSkillLogic` | `registerAssassinateFollowUpTeleport` | `self, player` | client | 1-21 |
| `PlayerSkillLogic` | `releaseDirectionKey` | `self, player` | client | 1-10 |
| `PlayerSkillLogic` | `releaseEffect` | `self, player, skillID, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `releaseEffectClient` | `self, player, skillID` | client | 1-38 |
| `PlayerSkillLogic` | `releaseHurricanePrepareEffectRemote` | `self, player, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `releaseHurricaneTrackedEffects` | `self, player, skillID, state` | client | 1-9 |
| `PlayerSkillLogic` | `releasePiercingPrepareEffectRemote` | `self, player, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `releasePiercingPrepareState` | `self, player, skillID, state` | client | 1-8 |
| `PlayerSkillLogic` | `releaseTrackedEffectEntities` | `self, entities` | client | 1-16 |
| `PlayerSkillLogic` | `removeDropFromExplodeClient` | `self, map, explodeList, exceptPlayer` | client | 1-28 |
| `PlayerSkillLogic` | `resetAllSkillCooldowns` | `self, player, exceptSkillID` | server-only | 1-3 |
| `PlayerSkillLogic` | `resetAllSkillCooldownsClient` | `self, player, exceptSkillID` | client | 1-3 |
| `PlayerSkillLogic` | `resetHurricaneHiddenKeydownState` | `self, player` | client | 1-6 |
| `PlayerSkillLogic` | `resetPiercingHiddenKeydownState` | `self, player` | client | 1-6 |
| `PlayerSkillLogic` | `restoreDefaultActionAfterKeydown` | `self, player` | client | 1-8 |
| `PlayerSkillLogic` | `restoreHurricaneActionAfterKeydown` | `self, player, state` | client | 1-15 |
| `PlayerSkillLogic` | `restorePiercingActionAfterKeydown` | `self, player` | client | 1-19 |
| `PlayerSkillLogic` | `scheduleAssassinateFinishAttack` | `self, player, skillID, skillLevel, lastAttackMobs` | client | 1-31 |
| `PlayerSkillLogic` | `scheduleAssassinateFollowUp` | `self, player, skillID, skillLevel` | client | 1-11 |
| `PlayerSkillLogic` | `setAvatarAlpha` | `self, player, alpha, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `setAvatarAlphaClient` | `self, player, alpha` | client | 1-6 |
| `PlayerSkillLogic` | `setCanUseSkillTime` | `self, player, skillID, nextTime` | client | 1-9 |
| `PlayerSkillLogic` | `setCanUseSkillTimeClient` | `self, player, skillID, nextTime` | client | 1-3 |
| `PlayerSkillLogic` | `setSkillCooldownEndTime` | `self, player, skillID, endTime` | client | 1-9 |
| `PlayerSkillLogic` | `setSkillCooldownEndTimeClient` | `self, player, skillID, endTime` | client | 1-3 |
| `PlayerSkillLogic` | `setTrackedEffectEntitiesRear` | `self, entities` | client | 1-11 |
| `PlayerSkillLogic` | `setVisibleEffect` | `self, player, skillID, visible, senderUserId` | server-only | 1-13 |
| `PlayerSkillLogic` | `setVisibleEffectClient` | `self, player, skillID, visible` | client | 1-20 |
| `PlayerSkillLogic` | `shiftThunderChargeToAssist` | `self, player` | server-only | 1-21 |
| `PlayerSkillLogic` | `shouldBlockOtherActionByExclusiveKeydown` | `self, player, skillID, endKeyDown` | client | 1-19 |
| `PlayerSkillLogic` | `shouldBlockWindArcherMorphAttackSkill` | `self, player, skillID, morphId` | client | 1-12 |
| `PlayerSkillLogic` | `shouldLogSkillActionLock` | `self, player` | client | 1-9 |
| `PlayerSkillLogic` | `shouldSyncTeleportLockWithAttack` | `self, skillID` | client | 1-5 |
| `PlayerSkillLogic` | `spawnHurricaneBulletClient` | `self, player, skillID` | client | 1-179 |
| `PlayerSkillLogic` | `startHiddenKeyDown` | `self, player, skillID` | client | 1-18 |
| `PlayerSkillLogic` | `startHurricaneKeyDownEffect` | `self, player, skillID, skillData` | client | 1-18 |
| `PlayerSkillLogic` | `startPiercingKeyDownEffect` | `self, player, skillID, skillData` | client | 1-25 |
| `PlayerSkillLogic` | `startPiercingKeydownFacingSync` | `self, player, skillID, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `startPiercingKeydownFacingSyncClient` | `self, player, skillID` | client | 1-78 |
| `PlayerSkillLogic` | `stopPiercingKeydownFacingSync` | `self, player, senderUserId` | server-only | 1-10 |
| `PlayerSkillLogic` | `stopPiercingKeydownFacingSyncClient` | `self, player` | client | 1-8 |
| `PlayerSkillLogic` | `syncLookDirectionByHorizontalInput` | `self, player` | client | 1-21 |
| `PlayerSkillLogic` | `syncPiercingChargeDirection` | `self, player` | client | 1-9 |
| `PlayerSkillLogic` | `triggerAssassinateFollowUp` | `self, player, skillID, skillLevel` | client | 1-16 |
| `PlayerSkillLogic` | `tryActiveSkill` | `self, caster, player, skillID, skillLevel, skillData, skillLevelData, totalTargetOnlyPlayer` | server-only | 1-56 |
| `PlayerSkillLogic` | `tryDoubleJump` | `self, player, fromSkillUse` | client | 1-136 |
| `PlayerSkillLogic` | `tryMesoExplosion` | `self, player, explodeList, senderUserId` | server-only | 1-36 |
| `PlayerSkillLogic` | `tryMesoExplosionClient` | `self, player, skillID, skillLevel, skillLevelData` | client | 1-248 |
| `PlayerSkillLogic` | `tryRush` | `self, player` | client | 1-53 |
| `PlayerSkillLogic` | `tryUseSkill` | `self, player, skillID, skillLevel, ctx, senderUserId` | server-only | 1-8 |
| `PlayerSkillLogic` | `tryUseSkillClient` | `self, player, skillID, skillLevel, endKeyDown, fromDoubleClick, afterPrepare` | client | 1-794 |
| `PlayerSkillLogic` | `tryUseSkillServerInternal` | `self, player, skillID, skillLevel, ctx` | server-only | 1-338 |
| `PlayerSkillLogic` | `tryWings` | `self, player, skillID, skillLevel, skillData` | client | 1-26 |
| `PlayerSkillLogic` | `usesLegacyCooldown` | `self, skillID` | client | 1-3 |
| `PlayerSkillLogic` | `verifyMobTargetsFromCtx` | `self, player, output, ctx, maxCount, skillBox` | server-only | 1-28 |
| `PlayerSkillLogic_Grenade` | `spawnPoisonBombMist` | `self, attacker, skillID, skillLevel, pos, senderUserId` | server-only | 1-29 |
| `PlayerSkillLogic_Grenade` | `tryGrenadeAttack` | `self, attacker, skillID, skillLevel, pos, isFinalAttack` | client | 1-103 |
| `PlayerSkillLogic_Teleport` | `checkTeleport` | `self, now` | client | 1-31 |
| `PlayerSkillLogic_Teleport` | `resetCamera` | `self` | client | 1-7 |
| `PlayerSkillLogic_Teleport` | `tryDoingTeleport` | `self, user, teleport` | client | 1-33 |
| `PlayerSkillLogic_Teleport` | `tryRegisterTeleport` | `self, user, skillId, skillLevel, portal, targetPortal, forced, forceRange` | client | 1-171 |
| `PlayerSkinType` | `getSkinRUID` | `self, index` | client | 1-3 |
| `PlayerSkinType` | `OnBeginPlay` | `self` | client | 1-21 |
| `PlayerStateLogic` | `changeState` | `self, player, state` | client | 1-30 |
| `PlayerTemporaryStatView` | `add` | `self, nID, durationSec, bNoShadow` | client | 1-89 |
| `PlayerTemporaryStatView` | `adjustPosition` | `self` | client | 1-18 |
| `PlayerTemporaryStatView` | `createGuildPassiveLayer` | `self` | client | 1-28 |
| `PlayerTemporaryStatView` | `findGuildBuffEntryIndex` | `self, buffId` | client | 1-9 |
| `PlayerTemporaryStatView` | `findID` | `self, layer` | client | 1-8 |
| `PlayerTemporaryStatView` | `getGuildBuffEntry` | `self, buffId` | client | 1-7 |
| `PlayerTemporaryStatView` | `getGuildPassiveEntry` | `self` | client | 1-10 |
| `PlayerTemporaryStatView` | `hideAll` | `self, currentTimeSec, durationSec` | client | 1-9 |
| `PlayerTemporaryStatView` | `hideEntry` | `self, e` | client | 1-6 |
| `PlayerTemporaryStatView` | `isGuildManagedBuffId` | `self, nID` | client | 1-3 |
| `PlayerTemporaryStatView` | `onMobileBuffTouchDown` | `self, event` | client | 1-9 |
| `PlayerTemporaryStatView` | `onMobileBuffTouchUp` | `self, event` | client | 1-46 |
| `PlayerTemporaryStatView` | `removeAt` | `self, i` | client | 1-23 |
| `PlayerTemporaryStatView` | `removeBySkillID` | `self, skillID` | client | 1-9 |
| `PlayerTemporaryStatView` | `removeGuildActiveBuffIcons` | `self` | client | 1-4 |
| `PlayerTemporaryStatView` | `removeGuildPassiveIcon` | `self` | client | 1-10 |
| `PlayerTemporaryStatView` | `reset` | `self` | client | 1-18 |
| `PlayerTemporaryStatView` | `setGuildActiveBuffIcon` | `self, buffId, remainSec, tooltipTitle, tooltipDesc` | client | 1-66 |
| `PlayerTemporaryStatView` | `setGuildPassiveIcon` | `self, tooltipDesc` | client | 1-55 |
| `PlayerTemporaryStatView` | `setLeft` | `self, e, newLeftSec` | client | 1-15 |
| `PlayerTemporaryStatView` | `showEntry` | `self, e` | client | 1-6 |
| `PlayerTemporaryStatView` | `tryCancelBuffLayer` | `self, layer` | client | 1-22 |
| `PlayerTemporaryStatView` | `update` | `self, currentTimeSec` | client | 1-39 |
| `PlayerTemporaryStatView` | `updateRemain` | `self, e` | client | 1-4 |
| `PlayerTemporaryStatView` | `updateShadowIndex` | `self, e` | client | 1-21 |
| `PlayerUpdateLogic` | `addHP` | `self, user, deltaHP` | server-only | 1-6 |
| `PlayerUpdateLogic` | `addMP` | `self, user, deltaMP` | server-only | 1-3 |
| `PlayerUpdateLogic` | `clearHealTrackByPlayerId` | `self, playerId` | server-only | 1-9 |
| `PlayerUpdateLogic` | `coliisionDetectFloat` | `self, ap` | client | 1-209 |
| `PlayerUpdateLogic` | `connectMouseMoveEvent` | `self` | client | 1-4 |
| `PlayerUpdateLogic` | `disconnectMouseMoveEvent` | `self` | client | 1-6 |
| `PlayerUpdateLogic` | `doHeal` | `self, user, delta, show` | server-only | 1-16 |
| `PlayerUpdateLogic` | `doHealMP` | `self, user, delta` | server-only | 1-4 |
| `PlayerUpdateLogic` | `ensureBerserkLoopLocal` | `self, player` | client | 1-17 |
| `PlayerUpdateLogic` | `get_cross_product` | `self, xOrg, yOrg, x1, y1, x2, y2` | client | 1-3 |
| `PlayerUpdateLogic` | `getBerserkLoopKey` | `self, player` | client | 1-6 |
| `PlayerUpdateLogic` | `getBerserkShouldActive` | `self, player` | client | 1-19 |
| `PlayerUpdateLogic` | `getBerserkSkillLevelData` | `self, player` | client | 1-10 |
| `PlayerUpdateLogic` | `getEndureSkillID` | `self, player` | client | 1-13 |
| `PlayerUpdateLogic` | `isBlockedArea` | `self, map, fhId1, fhId2, xWorld, yWorld` | client | 1-41 |
| `PlayerUpdateLogic` | `OnBeginPlay` | `self` | client | 1-30 |
| `PlayerUpdateLogic` | `onMouseMove` | `self` | client | 1-17 |
| `PlayerUpdateLogic` | `OnUpdate` | `self, delta` | client | 1-142 |
| `PlayerUpdateLogic` | `playBerserkEffectLocal` | `self, player` | client | 1-32 |
| `PlayerUpdateLogic` | `playIronBodyEffectLocal` | `self, player` | client | 1-52 |
| `PlayerUpdateLogic` | `playIronBodyEffectRemote` | `self, senderUserId` | server-only | 1-12 |
| `PlayerUpdateLogic` | `prepareChangeMapPosition` | `self, user` | client | 1-11 |
| `PlayerUpdateLogic` | `releaseBerserkEffectEntities` | `self, entities` | client | 1-15 |
| `PlayerUpdateLogic` | `resetProperty` | `self` | client | 1-30 |
| `PlayerUpdateLogic` | `setHP` | `self, user, hp` | server-only | 1-3 |
| `PlayerUpdateLogic` | `setMP` | `self, user, mp` | server-only | 1-3 |
| `PlayerUpdateLogic` | `showHeal` | `self, player, delta` | client | 1-13 |
| `PlayerUpdateLogic` | `sign` | `self, x` | client | 1-5 |
| `PlayerUpdateLogic` | `stopBerserkLoopLocal` | `self, player` | client | 1-13 |
| `PlayerUpdateLogic` | `syncBerserkActiveServer` | `self, active, senderUserId` | server-only | 1-9 |
| `PlayerUpdateLogic` | `tryAddHP` | `self, user, deltaHP` | server-only | 1-3 |
| `PlayerUpdateLogic` | `tryHealHP` | `self, senderUserId` | server-only | 1-52 |
| `PlayerUpdateLogic` | `tryHealMP` | `self, senderUserId` | server-only | 1-59 |
| `PlayerUpdateLogic` | `tryPotentialRecovery` | `self, user` | server-only | 1-31 |
| `PlayerUpdateLogic` | `tryUpdateBerserkState` | `self, user` | server-only | 1-10 |
| `PlayerUpdateLogic` | `updateBerserkEffectsClient` | `self, user` | client | 1-46 |
| `PlayerUpdateLogic` | `UpdateChasingDropForPet` | `self, cur, owner` | client | 1-97 |
| `PlayerUpdateLogic` | `updateTrembleEffect` | `self, cur` | client | 1-36 |
| `PlayerUtils` | `get_iPlayerID` | `self, playerId` | client | 1-3 |
| `PlayerUtils` | `get_LocalUser_iPlayerID` | `self` | client | 1-5 |
| `PlayerUtils` | `playerIdToUserId` | `self, playerId` | client | 1-3 |
| `PlayerUtils` | `validPlayer` | `self, userID` | server-only | 1-4 |
| `PlayerVecCtrl` | `Impact` | `self, user` | client | 1-39 |
| `PlayerVecCtrl` | `isImpactMoving` | `self` | client | 1-14 |
| `PlayerVecCtrl` | `OnUpdate` | `self, delta` | client | 1-34 |
| `PlayerVecCtrl` | `SetImpactNext` | `self, vx, vy, ignoreSpeedScale` | client | 1-26 |
| `PortalType` | `isCollisionPortal` | `self, pt` | client | 1-3 |
| `Portal_1` | `amoria_out` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `ariant_Agit` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `block_yuyuan` | `self, player, udc, portal` | server-only | 1-4 |
| `Portal_1` | `book` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `cacheScriptFunc` | `self` | server-only | 1-77 |
| `Portal_1` | `canEnterShaolinTopFloor` | `self, player` | server-only | 1-16 |
| `Portal_1` | `completeSecretLibraryDirection` | `self, senderUserId` | server-only | 1-17 |
| `Portal_1` | `crane_MR` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `crane_SS` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `cygnus_ExpeditionEnter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `Depart_Boss_F_Enter` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `Depart_BossEnter` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `Depart_goBack00` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `Depart_goBack01` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `Depart_goFoward0` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `Depart_goFoward1` | `self, player, udc` | server-only | 1-14 |
| `Portal_1` | `Depart_inSubway` | `self, player, udc` | server-only | 1-10 |
| `Portal_1` | `Depart_ToKerning` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `Depart_topFloor` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `Depart_topFloorEnter` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `Depart_topOut` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `dojang_QcheckSet` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `dollCave00` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `dollCave01` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `dollCave02` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `dracoout` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `dragonNest` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `end_black` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `end_cow` | `self, player, udc` | server-only | 1-8 |
| `Portal_1` | `enter_701210130` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `enter_701210131` | `self, player, udc` | server-only | 1-17 |
| `Portal_1` | `enter_701220351` | `self, player, udc` | server-only | 1-8 |
| `Portal_1` | `enter_701220352` | `self, player, udc` | server-only | 1-15 |
| `Portal_1` | `enter_701220600` | `self, player, udc` | server-only | 1-64 |
| `Portal_1` | `enter_701220601` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `enter_701220602` | `self, player, udc` | server-only | 1-9 |
| `Portal_1` | `enter_701220610` | `self, player, udc` | server-only | 1-10 |
| `Portal_1` | `enter_701220710` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `enter_701220711` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `enter_boss` | `self, player, udc, portal` | server-only | 1-16 |
| `Portal_1` | `enter_boss_CN` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `enter_bosswait` | `self, player, udc, portal` | server-only | 1-27 |
| `Portal_1` | `enter_shaolin_chief_priest_lobby` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `enter_shaolin_chief_priest_wait` | `self, player, udc` | server-only | 1-9 |
| `Portal_1` | `enterAchter` | `self, player, udc` | server-only | 1-26 |
| `Portal_1` | `EntereurelTW` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `enterEvanRoom` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `enterInfo` | `self, player, udc` | server-only | 1-16 |
| `Portal_1` | `enterMagiclibrar` | `self, player, udc` | server-only | 1-14 |
| `Portal_1` | `enterPort` | `self, player, udc` | server-only | 1-16 |
| `Portal_1` | `enterShaolinChiefPriestBattle` | `self, player, slot` | server-only | 1-8 |
| `Portal_1` | `enterShaolinChiefPriestReplay` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `evanAlone` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `evanGolemDoor` | `self, player, udc` | server-only | 1-18 |
| `Portal_1` | `evanlivingRoom` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `evanrivingroom` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `evanTogether` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `exit_701220310` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `find_james` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `find_secretRoom` | `self, player, udc, portal` | server-only | 1-26 |
| `Portal_1` | `findvioleta` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `foxLaidy_map` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `goto_701220350` | `self, player, udc, portal` | server-only | 1-14 |
| `Portal_1` | `goto_shaolin` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `gotocastle` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `gryphius` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `highposition` | `self, player, udc` | server-only | 1-47 |
| `Portal_1` | `in_701220200` | `self, player, udc, portal` | server-only | 1-8 |
| `Portal_1` | `in_701220300` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `in_secretroom` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `inERShip` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `into_701220310` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `investigate1` | `self, player, udc` | server-only | 1-13 |
| `Portal_1` | `investigate2` | `self, player, udc` | server-only | 1-36 |
| `Portal_1` | `knights_Summon` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `mayong` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `MD_drakeroom` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_error` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_golem` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_mushroom` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_pig` | `self, player, udc` | server-only | 1-23 |
| `Portal_1` | `MD_protect` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_rabbit` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_remember` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_roundTable` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_sand` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `MD_treasure` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `merStandAlone` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `met_in` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `met_out` | `self, player, udc` | server-only | 1-21 |
| `Portal_1` | `metro_Chat00` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `metro_firstSetting` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `metro_in00` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `minar_elli` | `self, player, udc` | server-only | 1-18 |
| `Portal_1` | `moonrabbit_takeawayitem` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `move_701220000` | `self, player, udc, portal` | server-only | 1-8 |
| `Portal_1` | `move_701220100` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `move_stage` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `nets_in` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `nets_out` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `ninja_boss_out` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `obstacle` | `self, player, udc, portal` | server-only | 1-47 |
| `Portal_1` | `out_701220601` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `out_701220610` | `self, player, udc, portal` | server-only | 1-32 |
| `Portal_1` | `out_701220710` | `self, player, udc, portal` | server-only | 1-7 |
| `Portal_1` | `out_701220711` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `out_boss` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `out_pepeking` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `out_shaolin_chief_priest_wait` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `party_portal` | `self, player, udc` | server-only | 1-18 |
| `Portal_1` | `pField_out` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `Pianus` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `piramid_Chat00` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `playSecretLibraryDirectionToClient` | `self` | client | 1-80 |
| `Portal_1` | `Portal_down` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `Portal_up` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `PRaid_B_Enter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `PRaid_D_Enter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `PRaid_FailEnter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `PRaid_Revive` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `PRaid_WinEnter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `prisonBreak_1stageEnter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `q62005_in` | `self, player, udc, portal` | server-only | 1-7 |
| `Portal_1` | `q62015_in` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `rankRoom` | `self, player, udc` | server-only | 1-30 |
| `Portal_1` | `Resi_tutor10` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `Resi_tutor50_1` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `Resi_tutor60` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `shammos_Base` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `shammos_Govalley` | `self, player, udc` | server-only | 1-10 |
| `Portal_1` | `shammos_Result` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `shammos_Start` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `shaolin_done` | `self, player, udc, portal` | server-only | 1-9 |
| `Portal_1` | `shaolin_next` | `self, player, udc, portal` | server-only | 1-8 |
| `Portal_1` | `shaolin_out` | `self, player, udc, portal` | server-only | 1-3 |
| `Portal_1` | `Sky_Quest` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `skyrom` | `self, player, udc` | server-only | 1-14 |
| `Portal_1` | `summondragon` | `self, player, udc` | server-only | 1-14 |
| `Portal_1` | `summonSchiller` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `TCMobrevive` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `TD_Boss_enter` | `self, player, udc` | server-only | 1-11 |
| `Portal_1` | `TD_MC_bossEnter` | `self, player, udc` | server-only | 1-57 |
| `Portal_1` | `TD_MC_Egate` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `TD_MC_enterboss1` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `TD_MC_enterboss2` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `TD_MC_faild` | `self, player, udc` | server-only | 1-3 |
| `Portal_1` | `TD_MC_first` | `self, player, udc` | server-only | 1-13 |
| `Portal_1` | `TD_MC_gasi` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `TD_MC_gasi2` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `TD_MC_jump` | `self, player, udc` | server-only | 1-5 |
| `Portal_1` | `TD_MC_keycheck` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `TD_MC_Openning` | `self, player, udc` | server-only | 1-12 |
| `Portal_1` | `TD_MC_title` | `self, player, udc` | server-only | 1-6 |
| `Portal_1` | `TD_MC_violetaEnter` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `TD_neo_BossEnter` | `self, player, udc` | server-only | 1-18 |
| `Portal_1` | `TD_neo_inTree` | `self, player, udc` | server-only | 1-32 |
| `Portal_1` | `third4_portal` | `self, player, udc` | server-only | 1-7 |
| `Portal_1` | `tryEnterShaolinChiefPriestQuestBattle` | `self, player` | server-only | 1-11 |
| `Portal_1` | `tutorialNPC` | `self, player, udc` | server-only | 1-28 |
| `Portal_1` | `userInBattleSquare` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `VanLeon_ExpeditionEnter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `visitor_ReviveMap` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `VisitorCubePhase00_Enter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `VisitorleaveDirectionMode` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `visitorPT_Enter` | `self, player, udc` | server-only | 1-4 |
| `Portal_1` | `WorldMovePortal` | `self, player, udc, portal` | server-only | 1-16 |
| `Portal_2` | `ariant_castle` | `self, player, udc` | server-only | 1-11 |
| `Portal_2` | `babyPigOut` | `self, player, udc` | server-only | 1-12 |
| `Portal_2` | `balogTemple` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `Portal_2` | `catPriest_map` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `clearRider` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `contactDragon` | `self, player, udc` | server-only | 1-7 |
| `Portal_2` | `dojang_tuto` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `dragoneyes` | `self, player, udc` | server-only | 1-8 |
| `Portal_2` | `eliza_Garden` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `enter_agit` | `self, player, udc` | server-only | 1-11 |
| `Portal_2` | `enter_earth00` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `enter_earth01` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `enterBlackBC` | `self, player, udc` | server-only | 1-26 |
| `Portal_2` | `enterBlackFrog` | `self, player, udc` | server-only | 1-23 |
| `Portal_2` | `enterBlackRoom` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `enterPottery` | `self, player, udc` | server-only | 1-15 |
| `Portal_2` | `enterSnowDragon` | `self, player, udc` | server-only | 1-30 |
| `Portal_2` | `evanEntrance` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `evanFall` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `evanGarden0` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `evanGarden1` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `exit_party6` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `goja_out` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `goldenShrine_Out` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `gotoAni` | `self, player, udc` | server-only | 1-16 |
| `Portal_2` | `gotoNext1` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `gotoNext2_1` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `gotoNext2_2` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `gotoNext3_1` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `gotoNext3_2` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `gotoNext3_3` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `in_crossRoad` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `in_cygnusGarden` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `in_future` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `in_knights` | `self, player, udc` | server-only | 1-9 |
| `Portal_2` | `in_knights01` | `self, player, udc` | server-only | 1-9 |
| `Portal_2` | `in_timeStar` | `self, player, udc` | server-only | 1-12 |
| `Portal_2` | `lionking` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `ludi021` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `magatia_dark0` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `MY_SG1` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `MY_SG2` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `out_Ani` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `out_animalshow` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `out_ghosthouse` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `OutDungeun` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `OutPerrion_1` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `OutPerrion_2` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `outSDI` | `self, player, udc` | server-only | 1-13 |
| `Portal_2` | `pachinko00` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `party6_stage800` | `self, player, udc` | server-only | 1-8 |
| `Portal_2` | `PPinkOut` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `q2073` | `self, player, udc` | server-only | 1-13 |
| `Portal_2` | `q3366out` | `self, player, udc` | server-only | 1-11 |
| `Portal_2` | `q3368out` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `raid_stage` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `rnj_clearQ` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `rnj_exit` | `self, player, udc` | server-only | 1-12 |
| `Portal_2` | `s4tornado_enter` | `self, player, udc` | server-only | 1-10 |
| `Portal_2` | `sao_out` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `Sky_Previous` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `Sky_ReviveOut` | `self, player, udc` | server-only | 1-5 |
| `Portal_2` | `stopIceWall` | `self, player, udc` | server-only | 1-11 |
| `Portal_2` | `StudioZone_out` | `self, player, udc` | server-only | 1-6 |
| `Portal_2` | `tristanEnter` | `self, player, udc` | server-only | 1-10 |
| `Portal_NPC` | `ariant_queens` | `self, player, udc` | server-only | 1-10 |
| `Portal_NPC` | `back_ludi` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `Portal_NPC` | `enter_Xerxes` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `goGoblin` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `goMonkey` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `in_chowBoss` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `in_fairyBoss` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `out_cygnus` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `out_elinCave` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `out_fairyBoss` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `out_Xerxes` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `piramid_in00` | `self, player, udc` | server-only | 1-6 |
| `Portal_NPC` | `portalnpc` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `rita` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `sao_fieldOut` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `sao_portal00` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `secretDoor` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `shammos_Gate` | `self, player, udc` | server-only | 1-6 |
| `Portal_NPC` | `Shaolin_notice` | `self, player, udc` | server-only | 1-24 |
| `Portal_NPC` | `Sky_Enter` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `Sky_Out` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `TD_chat_enter` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `thief_in1` | `self, player, udc` | server-only | 1-5 |
| `Portal_NPC` | `unityPortal2` | `self, player, udc` | server-only | 1-6 |
| `Portal_Test` | `_1stTowerTop` | `self, player, udc` | server-only | 1-28 |
| `Portal_Test` | `_2ndTowerTop` | `self, player, udc` | server-only | 1-20 |
| `Portal_Test` | `_3rdTowerTop` | `self, player, udc` | server-only | 1-20 |
| `Portal_Test` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `QuestManager` | `checkQuest` | `self, playerEntity, questID, state` | client | 1-166 |
| `QuestManager` | `checkQuestSkillCondition` | `self, playerEntity, skillList` | client | 1-24 |
| `QuestManager` | `copyLeafValues` | `self, t, parentActs, path` | client | 1-34 |
| `QuestManager` | `deepCache` | `self, node` | client | 1-33 |
| `QuestManager` | `getActByQuestID` | `self, questID` | client | 1-3 |
| `QuestManager` | `getAllQuestByNpcID` | `self, playerEntity, npcID` | client | 1-64 |
| `QuestManager` | `getAllQuestInfo` | `self` | client | 1-16 |
| `QuestManager` | `getAutoAcceptQuestInfoList` | `self, playerEntity` | client | 1-45 |
| `QuestManager` | `getAutoQuestInfoLists` | `self, playerEntity` | client | 1-55 |
| `QuestManager` | `getCheckByQuestID` | `self, questID` | client | 1-3 |
| `QuestManager` | `getContinuityQuest` | `self, questID` | client | 1-18 |
| `QuestManager` | `getNode` | `self, path` | client | 1-39 |
| `QuestManager` | `getQuestInfo` | `self, playerEntity, state` | client | 1-176 |
| `QuestManager` | `getQuestInfoByNpcID` | `self, player, npcID` | client | 1-43 |
| `QuestManager` | `getQuestInfoByQuestID` | `self, questID` | client | 1-3 |
| `QuestManager` | `getQuestItemInfo` | `self, itemID` | client | 1-3 |
| `QuestManager` | `getQuestItemMaxCount` | `self, questID, itemID` | client | 1-24 |
| `QuestManager` | `getQuestOwnedItemCount` | `self, playerEntity, itemId` | client | 1-15 |
| `QuestManager` | `getSayByQuestID` | `self, questID` | client | 1-3 |
| `QuestManager` | `isQuest2337CompletionMigrationTarget` | `self, playerId` | client | 1-6 |
| `QuestManager` | `isRepeatableQuestReady` | `self, playerEntity, questID` | client | 1-37 |
| `QuestManager` | `loadQuest` | `self` | client | 1-36 |
| `QuestManager` | `migrateQuest2337CompletionTime` | `self, questComponent, playerId` | client | 1-20 |
| `QuestManager` | `normalizeQuestConditionState` | `self, state` | client | 1-8 |
| `QuestManager` | `parseQuestData` | `self` | client | 1-354 |
| `QuestManager` | `removeExcludedQuestData` | `self, questData` | client | 1-5 |
| `QuestManager` | `tryAutoAcceptQuest` | `self, playerEntity, questID` | server-only | 1-40 |
| `QuestManager` | `tryAutoAcceptQuests` | `self, playerEntity` | server-only | 1-42 |
| `QuestManager` | `unwrap` | `self, v` | client | 1-3 |
| `QuestStateType` | `castFrom` | `self, state` | server-only | 1-11 |
| `Quest_1` | `cacheScriptFunc` | `self` | server-only | 1-78 |
| `Quest_1` | `completeHeroReunion` | `self, player, udc, questID, texts` | server-only | 1-11 |
| `Quest_1` | `q1021e` | `self, player, udc` | server-only | 1-24 |
| `Quest_1` | `q1021s` | `self, player, udc` | server-only | 1-32 |
| `Quest_1` | `q1028s` | `self, player, udc` | server-only | 1-15 |
| `Quest_1` | `q1048s` | `self, player, udc` | server-only | 1-99 |
| `Quest_1` | `q1049s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q1050s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q1051s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q1052s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q1053s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q1054s` | `self, player, udc` | server-only | 1-15 |
| `Quest_1` | `q2124e` | `self, player, udc` | server-only | 1-37 |
| `Quest_1` | `q2126e` | `self, player, udc` | server-only | 1-37 |
| `Quest_1` | `q2127e` | `self, player, udc` | server-only | 1-67 |
| `Quest_1` | `q2148s` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q2149s` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q2150s` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q2151s` | `self, player, udc` | server-only | 1-24 |
| `Quest_1` | `q2152s` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q2156e` | `self, player, udc` | server-only | 1-33 |
| `Quest_1` | `q2186e` | `self, player, udc` | server-only | 1-74 |
| `Quest_1` | `q2197e` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q2214e` | `self, player, udc` | server-only | 1-24 |
| `Quest_1` | `q2215e` | `self, player, udc` | server-only | 1-36 |
| `Quest_1` | `q2216s` | `self, player, udc` | server-only | 1-12 |
| `Quest_1` | `q2217s` | `self, player, udc` | server-only | 1-12 |
| `Quest_1` | `q2218s` | `self, player, udc` | server-only | 1-14 |
| `Quest_1` | `q2219s` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q2228s` | `self, player, udc` | server-only | 1-11 |
| `Quest_1` | `q2230e` | `self, player, udc` | server-only | 1-29 |
| `Quest_1` | `q2232e` | `self, player, udc` | server-only | 1-5 |
| `Quest_1` | `q2232s` | `self, player, udc` | server-only | 1-10 |
| `Quest_1` | `q2238s` | `self, player, udc` | server-only | 1-18 |
| `Quest_1` | `q2244e` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q2245s` | `self, player, udc` | server-only | 1-16 |
| `Quest_1` | `q2251e` | `self, player, udc` | server-only | 1-65 |
| `Quest_1` | `q2254s` | `self, player, udc` | server-only | 1-14 |
| `Quest_1` | `q2257e` | `self, player, udc` | server-only | 1-7 |
| `Quest_1` | `q2258e` | `self, player, udc` | server-only | 1-7 |
| `Quest_1` | `q2258s` | `self, player, udc` | server-only | 1-12 |
| `Quest_1` | `q2259s` | `self, player, udc` | server-only | 1-11 |
| `Quest_1` | `q2260e` | `self, player, udc` | server-only | 1-12 |
| `Quest_1` | `q2260s` | `self, player, udc` | server-only | 1-13 |
| `Quest_1` | `q2291e` | `self, player, udc` | server-only | 1-34 |
| `Quest_1` | `q2293s` | `self, player, udc` | server-only | 1-134 |
| `Quest_1` | `q2300e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2300eA` | `self, player, udc, questid` | server-only | 1-14 |
| `Quest_1` | `q2300eB` | `self, player, udc, questid` | server-only | 1-14 |
| `Quest_1` | `q2300s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2300sA` | `self, player, udc, questid` | server-only | 1-34 |
| `Quest_1` | `q2300sB` | `self, player, udc, questid` | server-only | 1-34 |
| `Quest_1` | `q2301e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2301s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2302e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2302s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2303e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2303s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2304e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2304s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2305e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2305s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2306e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2306s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2307e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2307s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2308e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2308s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2309e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2309s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2310e` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2310s` | `self, player, udc` | server-only | 1-3 |
| `Quest_1` | `q2314s` | `self, player, udc` | server-only | 1-12 |
| `Quest_1` | `q2322s` | `self, player, udc` | server-only | 1-13 |
| `Quest_1` | `q2325e` | `self, player, udc` | server-only | 1-9 |
| `Quest_1` | `q2327s` | `self, player, udc` | server-only | 1-13 |
| `Quest_1` | `q2332s` | `self, player, udc` | server-only | 1-7 |
| `Quest_1` | `q2333e` | `self, player, udc` | server-only | 1-18 |
| `Quest_1` | `q2333s` | `self, player, udc` | server-only | 1-26 |
| `Quest_1` | `q2334s` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q2335s` | `self, player, udc` | server-only | 1-24 |
| `Quest_1` | `q2338s` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q2342s` | `self, player, udc` | server-only | 1-21 |
| `Quest_1` | `q2344e` | `self, player, udc` | server-only | 1-14 |
| `Quest_1` | `q2344s` | `self, player, udc` | server-only | 1-40 |
| `Quest_1` | `q2363e` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q2369e` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q2374e` | `self, player, udc` | server-only | 1-22 |
| `Quest_1` | `q2490s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q2491s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q2492s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q2493s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q2576s` | `self, player, udc` | server-only | 1-21 |
| `Quest_1` | `q3108s` | `self, player, udc` | server-only | 1-10 |
| `Quest_1` | `q3116s` | `self, player, udc` | server-only | 1-34 |
| `Quest_1` | `q3118e` | `self, player, udc` | server-only | 1-30 |
| `Quest_1` | `q3118s` | `self, player, udc` | server-only | 1-24 |
| `Quest_1` | `q3122e` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q3122s` | `self, player, udc` | server-only | 1-30 |
| `Quest_1` | `q3125e` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q3125s` | `self, player, udc` | server-only | 1-30 |
| `Quest_1` | `q3250e` | `self, player, udc` | server-only | 1-21 |
| `Quest_1` | `q3250s` | `self, player, udc` | server-only | 1-26 |
| `Quest_1` | `q3301e` | `self, player, udc` | server-only | 1-46 |
| `Quest_1` | `q3303e` | `self, player, udc` | server-only | 1-46 |
| `Quest_1` | `q3305s` | `self, player, udc` | server-only | 1-23 |
| `Quest_1` | `q3306s` | `self, player, udc` | server-only | 1-23 |
| `Quest_1` | `q3314e` | `self, player, udc` | server-only | 1-54 |
| `Quest_1` | `q3320s` | `self, player, udc` | server-only | 1-15 |
| `Quest_1` | `q3321s` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q3353s` | `self, player, udc` | server-only | 1-14 |
| `Quest_1` | `q3354s` | `self, player, udc` | server-only | 1-15 |
| `Quest_1` | `q3360s` | `self, player, udc` | server-only | 1-33 |
| `Quest_1` | `q3382e` | `self, player, udc` | server-only | 1-68 |
| `Quest_1` | `q3452e` | `self, player, udc` | server-only | 1-49 |
| `Quest_1` | `q3455s` | `self, player, udc` | server-only | 1-26 |
| `Quest_1` | `q3514e` | `self, player, udc` | server-only | 1-17 |
| `Quest_1` | `q3523s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3524s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3525s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3526s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3527s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3529s` | `self, player, udc` | server-only | 1-8 |
| `Quest_1` | `q3539s` | `self, player, udc` | server-only | 1-7 |
| `Quest_1` | `q3714s` | `self, player, udc` | server-only | 1-16 |
| `Quest_1` | `q3715s` | `self, player, udc` | server-only | 1-4 |
| `Quest_1` | `q3759e` | `self, player, udc` | server-only | 1-21 |
| `Quest_1` | `q3833e` | `self, player, udc` | server-only | 1-162 |
| `Quest_1` | `q3933s` | `self, player, udc` | server-only | 1-26 |
| `Quest_1` | `q3941e` | `self, player, udc` | server-only | 1-27 |
| `Quest_1` | `q3941s` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q3953e` | `self, player, udc` | server-only | 1-35 |
| `Quest_1` | `q6030e` | `self, player, udc` | server-only | 1-15 |
| `Quest_1` | `q6031e` | `self, player, udc` | server-only | 1-20 |
| `Quest_1` | `q6032e` | `self, player, udc` | server-only | 1-19 |
| `Quest_1` | `q6033e` | `self, player, udc` | server-only | 1-43 |
| `Quest_1` | `q6036e` | `self, player, udc` | server-only | 1-26 |
| `Quest_1` | `q9251s` | `self, player, udc` | server-only | 1-5 |
| `Quest_1` | `q9252s` | `self, player, udc` | server-only | 1-5 |
| `Quest_1` | `q9253s` | `self, player, udc` | server-only | 1-5 |
| `Quest_1` | `q9254s` | `self, player, udc` | server-only | 1-5 |
| `Quest_1` | `setQuest6029Flag` | `self, player, index, value` | server-only | 1-28 |
| `Quest_2` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Quest_2` | `q10579s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `_shaolinCollectorComplete` | `self, player, udc, questId, itemId` | server-only | 1-10 |
| `Quest_3` | `_shaolinComplete` | `self, player, questId, expValue, exchangeItems` | server-only | 1-14 |
| `Quest_3` | `cacheScriptFunc` | `self` | server-only | 1-96 |
| `Quest_3` | `check_gyroDrop` | `self, player, udc` | server-only | 1-15 |
| `Quest_3` | `FantasticAnimalShow` | `self, player, udc` | server-only | 1-56 |
| `Quest_3` | `npc_9310580` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `npc_9310581` | `self, player, udc` | server-only | 1-21 |
| `Quest_3` | `npc_9310596` | `self, player, udc` | server-only | 1-28 |
| `Quest_3` | `offerShaolinMissingFriendsQuest` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `onFantasticAnimalShowMobDead` | `self, player, mobID` | server-only | 1-14 |
| `Quest_3` | `q20000s` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20001s` | `self, player, udc` | server-only | 1-27 |
| `Quest_3` | `q20002s` | `self, player, udc` | server-only | 1-18 |
| `Quest_3` | `q20010e` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q20010s` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20011e` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q20011s` | `self, player, udc` | server-only | 1-12 |
| `Quest_3` | `q20012e` | `self, player, udc` | server-only | 1-12 |
| `Quest_3` | `q20012s` | `self, player, udc` | server-only | 1-12 |
| `Quest_3` | `q20013e` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q20013s` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q20015s` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20016s` | `self, player, udc` | server-only | 1-24 |
| `Quest_3` | `q20017s` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20020s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q20100e` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q20101e` | `self, player, udc` | server-only | 1-21 |
| `Quest_3` | `q20102e` | `self, player, udc` | server-only | 1-21 |
| `Quest_3` | `q20103e` | `self, player, udc` | server-only | 1-21 |
| `Quest_3` | `q20104e` | `self, player, udc` | server-only | 1-21 |
| `Quest_3` | `q20105e` | `self, player, udc` | server-only | 1-22 |
| `Quest_3` | `q20200s` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q20201e` | `self, player, udc` | server-only | 1-20 |
| `Quest_3` | `q20202e` | `self, player, udc` | server-only | 1-20 |
| `Quest_3` | `q20203e` | `self, player, udc` | server-only | 1-20 |
| `Quest_3` | `q20204e` | `self, player, udc` | server-only | 1-20 |
| `Quest_3` | `q20205e` | `self, player, udc` | server-only | 1-20 |
| `Quest_3` | `q20311s` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `q20312s` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `q20313s` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `q20314s` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `q20315s` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `q20400s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q20401s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q20405s` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q20406s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q20408s` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q20520s` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q20522e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q20522s` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20526e` | `self, player, udc` | server-only | 1-13 |
| `Quest_3` | `q20526s` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q20527s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q20600s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q20610s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q20700s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q20710s` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q20720s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q21201s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q22100e` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q22100s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22101e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22101s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22102e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22103e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22103s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22104e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22104s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22105e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22105s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22106e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22107e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22107s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22108e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22108s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22109e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22109s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q22300e` | `self, player, udc` | server-only | 1-6 |
| `Quest_3` | `q22300s` | `self, player, udc` | server-only | 1-6 |
| `Quest_3` | `q23903e` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q29002s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29300e` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29300s` | `self, player, udc` | server-only | 1-6 |
| `Quest_3` | `q29400e` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29400s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29500e` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29500s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29501e` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29501s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29502e` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29502s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q29503e` | `self, player, udc` | server-only | 1-412 |
| `Quest_3` | `q29503s` | `self, player, udc` | server-only | 1-166 |
| `Quest_3` | `q29508e` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q29900e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29900s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29901e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29901s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29902e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29902s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29903e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29903s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29904e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29904s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29905e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29905s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29906e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29906s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29907e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29907s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29908e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29908s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29909e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29909s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29910e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29910s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29911e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29911s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29912e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29912s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29913e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29913s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29914e` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q29914s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q29924s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q29925s` | `self, player, udc` | server-only | 1-9 |
| `Quest_3` | `q29926s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q29927s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q29928s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q31304s` | `self, player, udc` | client | 1-14 |
| `Quest_3` | `q62000s` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q62001e` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q62001s` | `self, player, udc` | server-only | 1-6 |
| `Quest_3` | `q62002e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62002s` | `self, player, udc` | server-only | 1-6 |
| `Quest_3` | `q62003_check` | `self, player, udc` | server-only | 1-32 |
| `Quest_3` | `q62003e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62003s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q62005e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62005s` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q62007e` | `self, player, udc` | server-only | 1-8 |
| `Quest_3` | `q62007s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62008e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62008s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62009e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62010e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62010s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62011e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62011s` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q62013_item` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q62013e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62013s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62014s` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q62015e` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q62015s` | `self, player, udc` | server-only | 1-14 |
| `Quest_3` | `q62017s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q62018e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62018s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62019e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62019s` | `self, player, udc` | server-only | 1-4 |
| `Quest_3` | `q62020s` | `self, player, udc` | server-only | 1-10 |
| `Quest_3` | `q62021s` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `q62022e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62022s` | `self, player, udc` | server-only | 1-5 |
| `Quest_3` | `q62023s` | `self, player, udc` | server-only | 1-16 |
| `Quest_3` | `q62024e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62025e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62026e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62027e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62028e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62029e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62030e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62031e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62032e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62033e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62034e` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62035s` | `self, player, udc` | server-only | 1-15 |
| `Quest_3` | `q62036e` | `self, player, udc` | server-only | 1-7 |
| `Quest_3` | `q62037s` | `self, player, udc` | server-only | 1-3 |
| `Quest_3` | `q62039s` | `self, player, udc` | server-only | 1-15 |
| `Quest_3` | `shaolin_collector` | `self, player, udc` | server-only | 1-50 |
| `Quest_3` | `shaolin_martial_monk_entry` | `self, player, udc` | server-only | 1-17 |
| `Quest_3` | `shaolin_woodcutter` | `self, player, udc` | server-only | 1-44 |
| `Quest_3` | `shaolinBookNpc` | `self, player, udc` | server-only | 1-11 |
| `Quest_3` | `showShaolinChiefPriestCutsceneToClient` | `self, duration` | client | 1-30 |
| `Quest_3` | `spawnFantasticAnimalShowSpiegelmann` | `self, player` | server-only | 1-14 |
| `Quest_3` | `tryGiveShaolinYokaiBook` | `self, player, udc, unavailableMessage` | server-only | 1-25 |
| `Quest_Test` | `q10104e` | `self, player, udc` | server-only | 1-7 |
| `Quest_Test` | `q10105e` | `self, player, udc` | server-only | 1-7 |
| `Quest_Test` | `q10106e` | `self, player, udc` | server-only | 1-7 |
| `Quest_Test` | `q2238s` | `self, player, udc` | server-only | 1-5 |
| `Quest_Test` | `q22587s` | `self, player, udc` | server-only | 1-5 |
| `Quest_Test` | `q3933e` | `self, player, udc` | server-only | 1-4 |
| `ReactorManager` | `getReactor` | `self, id` | client | 1-3 |
| `ReactorManager` | `getReactorState` | `self, id, state` | client | 1-4 |
| `ReactorManager` | `loadReactor` | `self` | client | 1-127 |
| `Reactor_1` | `cacheScriptFunc` | `self` | server-only | 1-36 |
| `Reactor_1` | `ntQuest01` | `self, player, udc` | server-only | 1-7 |
| `Reactor_1` | `ntQuest02` | `self, player, udc` | server-only | 1-6 |
| `ReportLogic` | `enqueueUserReportRequest` | `self, reporter, reported, reason, description, dailyReportCount` | server-only | 1-38 |
| `ReportLogic` | `findReportTargetInSameInstance` | `self, reporter, targetName` | server-only | 1-13 |
| `ReportLogic` | `getDailyReportCount` | `self, user` | server-only | 1-20 |
| `ReportLogic` | `getReportAccountId` | `self, user` | server-only | 1-12 |
| `ReportLogic` | `getReportMapName` | `self, user` | server-only | 1-13 |
| `ReportLogic` | `getReportPlayerId` | `self, user` | server-only | 1-6 |
| `ReportLogic` | `hasReportedTargetToday` | `self, user, targetName` | server-only | 1-16 |
| `ReportLogic` | `markReportedTargetToday` | `self, user, targetName` | server-only | 1-25 |
| `ReportLogic` | `onDailyReportCountClient` | `self, count, limit` | client | 1-6 |
| `ReportLogic` | `onSubmitReportResultClient` | `self, success, message` | client | 1-11 |
| `ReportLogic` | `requestDailyReportCountServer` | `self, senderUserId` | server-only | 1-9 |
| `ReportLogic` | `setDailyReportCount` | `self, user, count` | server-only | 1-9 |
| `ReportLogic` | `submitReportServer` | `self, targetName, reason, description, senderUserId` | server-only | 1-58 |
| `RichTextUtils` | `isStrippableColorShorthand` | `self, tagBody` | client | 1-7 |
| `RichTextUtils` | `isStrippableOpeningTag` | `self, tagName` | client | 1-37 |
| `RichTextUtils` | `stripRichTextCommands` | `self, message` | client | 1-35 |
| `Scavenger` | `cacheScriptFunc` | `self` | server-only | 1-13 |
| `Scavenger` | `sca_auto` | `self, player, udc` | server-only | 1-17 |
| `Scavenger` | `sca_boogi` | `self, player, udc` | server-only | 1-13 |
| `Scavenger` | `sca_DitRoi` | `self, player, udc` | server-only | 1-19 |
| `Scavenger` | `sca_dollBear` | `self, player, udc` | server-only | 1-17 |
| `Scavenger` | `sca_fv0` | `self, player, udc` | server-only | 1-13 |
| `Scavenger` | `sca_lich0` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich1` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich2` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich3` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich4` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich5` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich6` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_lich7` | `self, player, udc` | server-only | 1-12 |
| `Scavenger` | `sca_maga0` | `self, player, udc` | server-only | 1-13 |
| `Scavenger` | `sca_maga1` | `self, player, udc` | server-only | 1-13 |
| `Scavenger` | `sca_maga2` | `self, player, udc` | server-only | 1-13 |
| `Scavenger` | `sca_Shade` | `self, player, udc` | server-only | 1-19 |
| `Scavenger` | `sca_snow0` | `self, player, udc` | server-only | 1-19 |
| `ScriptLogic` | `animationDisplay` | `self, p, path` | server-only | 1-27 |
| `ScriptLogic` | `animationDisplayToClient` | `self, path` | client | 1-259 |
| `ScriptLogic` | `appendQuestRewardText` | `self, text, player, item, exp, pop, meso, skill, propList, itemTable` | client | 1-61 |
| `ScriptLogic` | `cacheScriptFunc` | `self` | server-only | 1-34 |
| `ScriptLogic` | `cancelItem` | `self, player, itemId` | server-only | 1-18 |
| `ScriptLogic` | `canCheckData` | `self, checkData, stop, player, questID` | server-only | 1-157 |
| `ScriptLogic` | `canGainItems` | `self, player, rewards, defaultFlag` | server-only | 1-93 |
| `ScriptLogic` | `canGainItemWithFlag` | `self, player, itemID, itemCount, itemFlag` | server-only | 1-62 |
| `ScriptLogic` | `canGainRewardItems` | `self, player, rewards` | server-only | 1-86 |
| `ScriptLogic` | `canhold` | `self, player, itemID` | server-only | 1-6 |
| `ScriptLogic` | `changeJob` | `self, player, job` | server-only | 1-5 |
| `ScriptLogic` | `checkJobByAct` | `self, job, flag` | client | 1-10 |
| `ScriptLogic` | `ClearSaveLocation` | `self, player, location` | server-only | 1-3 |
| `ScriptLogic` | `currentTime` | `self` | server-only | 1-3 |
| `ScriptLogic` | `dropMessage` | `self, player, type, text` | server-only | 1-7 |
| `ScriptLogic` | `effectSound` | `self, p, path` | server-only | 1-4 |
| `ScriptLogic` | `effectSoundStop` | `self, p, path` | server-only | 1-4 |
| `ScriptLogic` | `exchange` | `self, player, values, showMessage, exchangeFlag` | server-only | 1-274 |
| `ScriptLogic` | `gainExp` | `self, player, exp, showMessage` | server-only | 1-14 |
| `ScriptLogic` | `gainItem` | `self, player, itemID, itemCount` | server-only | 1-69 |
| `ScriptLogic` | `gainItemPeriod` | `self, player, itemID, days, hour, minute, second` | server-only | 1-40 |
| `ScriptLogic` | `gainItems` | `self, player, rewards, defaultFlag, showMessage` | server-only | 1-3 |
| `ScriptLogic` | `gainItemsWithFlag` | `self, player, rewards, defaultFlag, rewardAction, sourceId, showMessage` | server-only | 1-36 |
| `ScriptLogic` | `gainItemWithFlag` | `self, player, itemID, itemCount, itemFlag, showMessage` | server-only | 1-57 |
| `ScriptLogic` | `gainMeso` | `self, player, meso` | server-only | 1-7 |
| `ScriptLogic` | `gainpop` | `self, player, pop` | server-only | 1-9 |
| `ScriptLogic` | `gainRewardItems` | `self, player, rewards, rewardAction, sourceId, showMessage` | server-only | 1-35 |
| `ScriptLogic` | `getCharactersSize` | `self, mapID` | server-only | 1-7 |
| `ScriptLogic` | `getDefaultItemFlag` | `self, itemID` | server-only | 1-21 |
| `ScriptLogic` | `getDistance` | `self, player` | server-only | 1-22 |
| `ScriptLogic` | `getFieldID` | `self, player` | server-only | 1-15 |
| `ScriptLogic` | `getIntNoRecord` | `self, player, questID` | server-only | 1-3 |
| `ScriptLogic` | `getItemCount` | `self, player, itemID` | server-only | 1-5 |
| `ScriptLogic` | `getJob` | `self, player` | server-only | 1-7 |
| `ScriptLogic` | `getKeyvalue` | `self, player, key` | server-only | 1-7 |
| `ScriptLogic` | `getLevel` | `self, player` | server-only | 1-7 |
| `ScriptLogic` | `getMeso` | `self, player` | server-only | 1-8 |
| `ScriptLogic` | `getMobCount` | `self, player` | server-only | 1-7 |
| `ScriptLogic` | `getMobCountForMap` | `self, mapId` | server-only | 1-6 |
| `ScriptLogic` | `getMorphID` | `self, player` | server-only | 1-3 |
| `ScriptLogic` | `getNpcCount` | `self, player` | server-only | 1-16 |
| `ScriptLogic` | `getNpcID` | `self, player` | server-only | 1-7 |
| `ScriptLogic` | `getNpcPosition` | `self, player` | server-only | 1-13 |
| `ScriptLogic` | `getQuestEx` | `self, player, questID` | server-only | 1-3 |
| `ScriptLogic` | `getQuestExpBonus` | `self, player, exp` | server-only | 1-6 |
| `ScriptLogic` | `getQuestExRecord` | `self, player, questID, qex` | server-only | 1-7 |
| `ScriptLogic` | `getRemainingSp` | `self, player` | server-only | 1-7 |
| `ScriptLogic` | `GetSaveLocation` | `self, player, location` | server-only | 1-5 |
| `ScriptLogic` | `getSkillLevel` | `self, player, skillID` | server-only | 1-7 |
| `ScriptLogic` | `getSpaceSlotCount` | `self, p, type` | server-only | 1-5 |
| `ScriptLogic` | `getWeekStartMonday` | `self, dateTime` | server-only | 1-12 |
| `ScriptLogic` | `handleMobDeadQuests` | `self, attacker, mobID` | server-only | 1-21 |
| `ScriptLogic` | `hasBuffBySkillID` | `self, player, skillID` | server-only | 1-20 |
| `ScriptLogic` | `hireTutor` | `self, player, spawn` | server-only | 1-38 |
| `ScriptLogic` | `incHP` | `self, player, delta` | server-only | 1-3 |
| `ScriptLogic` | `incInventorySlot` | `self, player, invType, inc` | server-only | 1-3 |
| `ScriptLogic` | `isPartyLeader` | `self, player` | server-only | 1-3 |
| `ScriptLogic` | `killAllMonster` | `self, mapID` | server-only | 1-7 |
| `ScriptLogic` | `killMonster` | `self, mapID, mobID` | server-only | 1-8 |
| `ScriptLogic` | `lockUI` | `self` | client | 1-10 |
| `ScriptLogic` | `message` | `self, player, text` | server-only | 1-3 |
| `ScriptLogic` | `onCharacterEffect` | `self, path` | client | 1-40 |
| `ScriptLogic` | `onNpcEffect` | `self, npcID, path` | client | 1-46 |
| `ScriptLogic` | `onSummonEffect` | `self, path` | client | 1-3 |
| `ScriptLogic` | `onSummonEffectRetry` | `self, path, retryCount` | client | 1-61 |
| `ScriptLogic` | `openNPC` | `self, player, npcID` | server-only | 1-14 |
| `ScriptLogic` | `passedByMidnight` | `self, current, target` | server-only | 1-11 |
| `ScriptLogic` | `passedByWeek` | `self, current, target` | server-only | 1-12 |
| `ScriptLogic` | `pickByWeightWithShuffle` | `self, list` | client | 1-31 |
| `ScriptLogic` | `playPortalSE` | `self, player` | server-only | 1-4 |
| `ScriptLogic` | `qrGetState` | `self, player, questID` | server-only | 1-7 |
| `ScriptLogic` | `qrSetState` | `self, player, questID, state` | server-only | 1-8 |
| `ScriptLogic` | `questDialog` | `self, player, questID, state, npcID` | server-only | 1-486 |
| `ScriptLogic` | `registerTransferField` | `self, user, fieldID, portal, senderUserId` | server-only | 1-41 |
| `ScriptLogic` | `registerTransferFieldPos` | `self, user, fieldID, pos` | server-only | 1-18 |
| `ScriptLogic` | `removeAll` | `self, player, itemid` | server-only | 1-6 |
| `ScriptLogic` | `removeNpc` | `self, mapID, npcID` | server-only | 1-4 |
| `ScriptLogic` | `resetMAP` | `self, mapID` | server-only | 1-4 |
| `ScriptLogic` | `resetMorph` | `self, player` | server-only | 1-12 |
| `ScriptLogic` | `resolveGainItemFlag` | `self, itemID, rowFlag, defaultFlag` | server-only | 1-13 |
| `ScriptLogic` | `runPortalSC` | `self, player, scriptName` | server-only | 1-3 |
| `ScriptLogic` | `runScript` | `self, player, portal, scriptName, onUserEnter, onScript, itemNpcID` | server-only | 1-279 |
| `ScriptLogic` | `sendMessage` | `self, cName, msg` | server-only | 1-10 |
| `ScriptLogic` | `setKeyvalue` | `self, player, key, value` | server-only | 1-6 |
| `ScriptLogic` | `setNpcSpecialAction` | `self, player, npcID, action, broadcast` | server-only | 1-17 |
| `ScriptLogic` | `setQuestEx` | `self, player, questID, value` | server-only | 1-3 |
| `ScriptLogic` | `setQuestExRecord` | `self, player, questID, qex, value` | server-only | 1-7 |
| `ScriptLogic` | `SetSaveLocation` | `self, player, location` | server-only | 1-6 |
| `ScriptLogic` | `showScreenEffect` | `self, path` | client | 1-30 |
| `ScriptLogic` | `showTimedScreenEffect` | `self, path, duration` | client | 1-37 |
| `ScriptLogic` | `spawnMob` | `self, mapID, mobID, x, y` | server-only | 1-8 |
| `ScriptLogic` | `spawnNpc` | `self, mapID, npcID, x, y` | server-only | 1-7 |
| `ScriptLogic` | `summonMob` | `self, mapID, itemID, x, y` | server-only | 1-7 |
| `ScriptLogic` | `teachSkill` | `self, player, skillID, skillLevel, masterLevel` | server-only | 1-6 |
| `ScriptLogic` | `timeMoveMap` | `self, user, tomap, boatmap, sec` | server-only | 1-4 |
| `ScriptLogic` | `tutorMsg` | `self, player, type` | server-only | 1-4 |
| `ScriptLogic` | `unLockUI` | `self` | client | 1-11 |
| `ScriptLogic` | `useItem` | `self, player, itemId` | server-only | 1-58 |
| `ScriptLogic` | `warpParty` | `self, player, mapID, portal` | server-only | 1-63 |
| `ServerDataSetManager` | `applyMissingShieldPDDMDD` | `self, user, ieqp` | server-only | 1-46 |
| `ServerDataSetManager` | `bumpCashShopDataVersion` | `self` | server-only | 1-3 |
| `ServerDataSetManager` | `getCashShopCategoryRows` | `self` | server-only | 1-3 |
| `ServerDataSetManager` | `getCashShopCommodityRows` | `self` | server-only | 1-3 |
| `ServerDataSetManager` | `getReactorAction` | `self, actionName` | server-only | 1-3 |
| `ServerDataSetManager` | `getReactorReward` | `self, reactorId` | server-only | 1-3 |
| `ServerDataSetManager` | `getReward` | `self, mobId` | server-only | 1-3 |
| `ServerDataSetManager` | `getShop` | `self, npcId` | server-only | 1-3 |
| `ServerDataSetManager` | `isMissingShieldPDDMDD` | `self, ieqp` | server-only | 1-13 |
| `ServerDataSetManager` | `loadCashShopCategoryFromRows` | `self, rows` | server-only | 1-25 |
| `ServerDataSetManager` | `loadCashShopCommodityFromRows` | `self, rows` | server-only | 1-30 |
| `ServerDataSetManager` | `loadCashShopDataFromRequestService` | `self, onCompleted` | server-only | 1-44 |
| `ServerDataSetManager` | `loadDataSet` | `self` | server-only | 1-10 |
| `ServerDataSetManager` | `loadMissingShieldPDDMDD` | `self` | server-only | 1-16 |
| `ServerDataSetManager` | `loadReactorAction` | `self` | server-only | 1-38 |
| `ServerDataSetManager` | `loadReactorReward` | `self` | server-only | 1-31 |
| `ServerDataSetManager` | `loadReward` | `self` | server-only | 1-30 |
| `ServerDataSetManager` | `loadRewardFromRows` | `self, rows` | server-only | 1-34 |
| `ServerDataSetManager` | `loadShop` | `self` | server-only | 1-25 |
| `ServerDataSetManager` | `loadShopFromRows` | `self, rows` | server-only | 1-24 |
| `ServerDataSetManager` | `loadShopRewardFromRequestService` | `self, onCompleted` | server-only | 1-54 |
| `ServerDataSetManager` | `reloadShopRewardData` | `self` | server-only | 1-5 |
| `ShaolinChiefPriestBattleLogic` | `canUseShaolinSummon` | `self, mob, skillInfo, msd, temporary` | client | 1-12 |
| `ShaolinChiefPriestBattleLogic` | `executeFixedAttackClient` | `self, mob, attackInfo, attackIdx` | client | 1-26 |
| `ShaolinChiefPriestBattleLogic` | `executeFixedDamageClient` | `self, mob, skillID, skillLevel, delay` | client | 1-44 |
| `ShaolinChiefPriestBattleLogic` | `executeSkill` | `self, mob, skillID, skillLevel, skill, delay` | server-only | 1-60 |
| `ShaolinChiefPriestBattleLogic` | `getAliveSummonCount` | `self, map, summonMobId` | client | 1-18 |
| `ShaolinChiefPriestBattleLogic` | `isChiefPriest` | `self, mobID` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `isChiefPriestMist` | `self, skillId, skillLevel, isMobMist` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `isManagedSkill` | `self, mobID, skillID` | server-only | 1-7 |
| `ShaolinChiefPriestBattleLogic` | `isShaolinBoss` | `self, mobID` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `isShaolinPriest` | `self, mobID` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `shaolinSummonLimit` | `self` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `shaolinSummonMobId` | `self` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `shouldHandleShaolinManagedSkill` | `self, mobID, skillID` | client | 1-3 |
| `ShaolinChiefPriestBattleLogic` | `shouldUseFixedRatioAttackClient` | `self, templateId, attackInfo` | client | 1-3 |
| `ShaolinChiefPriestExpedition` | `accept` | `self, player, udc` | server-only | 1-88 |
| `ShaolinChiefPriestExpedition` | `addLeaderCount` | `self, player` | server-only | 1-7 |
| `ShaolinChiefPriestExpedition` | `addMember` | `self, mapId, name` | server-only | 1-11 |
| `ShaolinChiefPriestExpedition` | `addWeeklyCount` | `self, player` | server-only | 1-8 |
| `ShaolinChiefPriestExpedition` | `banMember` | `self, player, udc, mapId` | server-only | 1-33 |
| `ShaolinChiefPriestExpedition` | `cacheScriptFunc` | `self` | server-only | 1-3 |
| `ShaolinChiefPriestExpedition` | `canEnter` | `self, player, udc` | server-only | 1-12 |
| `ShaolinChiefPriestExpedition` | `clearRegistration` | `self, mapId` | server-only | 1-11 |
| `ShaolinChiefPriestExpedition` | `ensureNpc` | `self, mapId` | server-only | 1-8 |
| `ShaolinChiefPriestExpedition` | `getBattleMapId` | `self, slot` | server-only | 1-3 |
| `ShaolinChiefPriestExpedition` | `getBossFieldSet` | `self, slot` | server-only | 1-3 |
| `ShaolinChiefPriestExpedition` | `getEnterFieldSet` | `self, slot` | server-only | 1-3 |
| `ShaolinChiefPriestExpedition` | `getLeaderCount` | `self, player` | server-only | 1-8 |
| `ShaolinChiefPriestExpedition` | `getReg` | `self, mapId, key` | server-only | 1-4 |
| `ShaolinChiefPriestExpedition` | `getRosterText` | `self, mapId` | server-only | 1-13 |
| `ShaolinChiefPriestExpedition` | `getSlotByMapId` | `self, mapId` | server-only | 1-11 |
| `ShaolinChiefPriestExpedition` | `getWaitMapId` | `self, slot` | server-only | 1-3 |
| `ShaolinChiefPriestExpedition` | `getWeekId` | `self` | server-only | 1-16 |
| `ShaolinChiefPriestExpedition` | `getWeeklyCount` | `self, player` | server-only | 1-8 |
| `ShaolinChiefPriestExpedition` | `isBanned` | `self, mapId, name` | server-only | 1-9 |
| `ShaolinChiefPriestExpedition` | `isBattleMember` | `self, slot, name` | server-only | 1-15 |
| `ShaolinChiefPriestExpedition` | `isRegistered` | `self, mapId, name` | server-only | 1-13 |
| `ShaolinChiefPriestExpedition` | `isSlotBusy` | `self, slot` | server-only | 1-6 |
| `ShaolinChiefPriestExpedition` | `removeMember` | `self, mapId, name` | server-only | 1-9 |
| `ShaolinChiefPriestExpedition` | `resetWeeklyEntry` | `self, player` | server-only | 1-7 |
| `ShaolinChiefPriestExpedition` | `setReg` | `self, mapId, key, value` | server-only | 1-6 |
| `ShaolinChiefPriestExpedition` | `showLobby` | `self, player, udc` | server-only | 1-34 |
| `ShaolinChiefPriestExpedition` | `startBattle` | `self, leader, udc, slot` | server-only | 1-87 |
| `ShaolinMartialMonkParty` | `canEnter` | `self, player, udc` | server-only | 1-21 |
| `ShaolinMartialMonkParty` | `collectEntryMembers` | `self, player, udc` | server-only | 1-52 |
| `ShaolinMartialMonkParty` | `getFieldSet` | `self` | server-only | 1-3 |
| `ShaolinMartialMonkParty` | `hasEnteredToday` | `self, player` | server-only | 1-10 |
| `ShaolinMartialMonkParty` | `startBattle` | `self, player, udc` | server-only | 1-54 |
| `ShaolinMartialMonkParty` | `validateMembers` | `self, members, udc` | server-only | 1-24 |
| `Ship` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Ship` | `contimoveEliEre` | `self, player, udc` | server-only | 1-13 |
| `Ship` | `contimoveEreEli` | `self, player, udc` | server-only | 1-18 |
| `Ship` | `contimoveEreOrb` | `self, player, udc` | server-only | 1-13 |
| `Ship` | `contimoveOrbEre` | `self, player, udc` | server-only | 1-18 |
| `Ship` | `contimoveRieRit` | `self, player, udc` | server-only | 1-25 |
| `Ship` | `contimoveRitRie` | `self, player, udc` | server-only | 1-18 |
| `Ship` | `contimoveRitSDI` | `self, player, udc` | server-only | 1-16 |
| `Ship` | `contimoveSDIRit` | `self, player, udc` | server-only | 1-12 |
| `Ship` | `elevator` | `self, p` | server-only | 1-21 |
| `Ship` | `get_ticket` | `self, player, udc` | server-only | 1-56 |
| `Ship` | `goOutWaitingRoom` | `self, player, udc` | server-only | 1-16 |
| `Ship` | `move_EliEre` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_elin` | `self, player, udc` | server-only | 1-7 |
| `Ship` | `move_EreEli` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_EreOrb` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_OrbEre` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_RieRit` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_RitRie` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_RitSDI` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `move_SDIRit` | `self, player, udc` | server-only | 1-3 |
| `Ship` | `sell_ticket` | `self, player, udc` | server-only | 1-136 |
| `SkillLogic` | `calcBeginnerSP` | `self, player` | client | 1-41 |
| `SkillLogic` | `checkCanUpSP` | `self, player, skillID` | client | 1-50 |
| `SkillLogic` | `clearUseSP` | `self` | client | 1-8 |
| `SkillLogic` | `getComboDamageParam` | `self, player, skillID` | client | 1-61 |
| `SkillLogic` | `getCooltime` | `self, skillID` | client | 1-10 |
| `SkillLogic` | `getElementByCharge` | `self, skillID` | client | 1-13 |
| `SkillLogic` | `getJobClass` | `self, job` | client | 1-3 |
| `SkillLogic` | `getJobGroupFromJobId` | `self, jobId` | client | 1-11 |
| `SkillLogic` | `getJobGroupFromSkillId` | `self, skillId` | client | 1-5 |
| `SkillLogic` | `getJobIdFromSkillId` | `self, skillId` | client | 1-13 |
| `SkillLogic` | `getJobTier` | `self, job` | client | 1-27 |
| `SkillLogic` | `getMaxGaugeTime` | `self, skillID` | client | 1-20 |
| `SkillLogic` | `getMobColorByMTS` | `self, skillID` | client | 1-20 |
| `SkillLogic` | `getRecommendedTierSpendLimit` | `self, player, jobTier` | client | 1-18 |
| `SkillLogic` | `getSkillType` | `self, skillID` | client | 1-35 |
| `SkillLogic` | `isBeginnerSkill` | `self, skillID` | client | 1-13 |
| `SkillLogic` | `isCanNotJumpAttack` | `self, skillID` | client | 1-10 |
| `SkillLogic` | `isCanUseSkillOnLadder` | `self, skillID` | client | 1-9 |
| `SkillLogic` | `isComboFinishAttack` | `self, skillID` | client | 1-8 |
| `SkillLogic` | `isCooltimeSkill` | `self, skillID` | client | 1-6 |
| `SkillLogic` | `isDragonRoar` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `isHeal` | `self, skillID` | client | 1-3 |
| `SkillLogic` | `isIgnoreCriticalSkill` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `isIgnoreMGuardUpSkill` | `self, skillID` | client | 1-4 |
| `SkillLogic` | `isIgnorePDefSkill` | `self, skillID` | client | 1-5 |
| `SkillLogic` | `isIgnorePGuardUpSkill` | `self, skillID` | client | 1-4 |
| `SkillLogic` | `isKeyDownSkill` | `self, skillID` | client | 1-9 |
| `SkillLogic` | `isMoveAffectedSkill` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `isNoClearSkill` | `self, skillID` | client | 1-5 |
| `SkillLogic` | `isRushAttackSkill` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `isTeleportAttackSkill` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `isTeleportSkill` | `self, skillId` | client | 1-12 |
| `SkillLogic` | `isThrowBombSkill` | `self, skillID` | client | 1-4 |
| `SkillLogic` | `isTrembleAttackSkill` | `self, skillID` | client | 1-7 |
| `SkillLogic` | `shouldConfirmInvestForNextTier` | `self, player, skillID, gainLevel` | client | 1-35 |
| `SkillLogic` | `updateUseSP` | `self, jobTier, delta` | client | 1-7 |
| `SkillManager` | `ensureAttackTypeLoaded` | `self` | client | 1-23 |
| `SkillManager` | `ensureMobSkillLoaded` | `self` | client | 1-28 |
| `SkillManager` | `ensureSkillLoaded` | `self, jobId` | client | 1-26 |
| `SkillManager` | `extractSkillOrder` | `self, rawData` | client | 1-79 |
| `SkillManager` | `get_novice_skill_as_race` | `self, skillID, jobID` | client | 1-7 |
| `SkillManager` | `getAttackType` | `self, attackTypeId` | client | 1-6 |
| `SkillManager` | `getAttackTypeLevelData` | `self, attackTypeId, level` | client | 1-12 |
| `SkillManager` | `getHitUOLByIndex` | `self, skillID, charLevel, SLV, idx` | client | 1-9 |
| `SkillManager` | `getMobSkill` | `self, skillId, level` | client | 1-7 |
| `SkillManager` | `getRandomHitUOL` | `self, skillID, charLevel, SLV` | client | 1-12 |
| `SkillManager` | `getSkill` | `self, skillId` | client | 1-15 |
| `SkillManager` | `getSkillBook` | `self, jobId` | client | 1-12 |
| `SkillManager` | `getSkillLevelData` | `self, skillId, level` | client | 1-12 |
| `SkillManager` | `getSkillsByJobId` | `self, jobId` | client | 1-12 |
| `SkillManager` | `loadSkill` | `self` | client | 1-11 |
| `SkillManager` | `loadSkillFull` | `self` | client | 1-63 |
| `SkillManager` | `loadSkillLazy` | `self` | client | 1-52 |
| `SkillManager` | `parseAttackTypeData` | `self, data` | client | 1-19 |
| `SkillManager` | `parseJobSkillBook` | `self, jobId, data, skillBook, rawData` | client | 1-346 |
| `SkillManager` | `parseMobSkillData` | `self, data` | client | 1-20 |
| `SkillManager` | `parseSkillLevelData` | `self, skill` | client | 1-124 |
| `SkillManager` | `split_tail_number` | `self, str` | client | 1-10 |
| `SoundUtils` | `broadcastCashStickerHitSoundAtPosLocal` | `self, path, target, volume, isLocalAttacker` | client | 1-23 |
| `SoundUtils` | `broadcastPlayerSkillSoundAtPosRemote` | `self, path, speaker, volume, senderUserId` | server-only | 1-11 |
| `SoundUtils` | `broadcastSoundAtPosByRUIDLocal` | `self, ruid, player, target, volume` | client | 1-6 |
| `SoundUtils` | `broadcastSoundAtPosLocal` | `self, path, player, volume` | client | 1-7 |
| `SoundUtils` | `broadcastSoundAtPosRemote` | `self, path, player, volume, senderUserId` | server-only | 1-10 |
| `SoundUtils` | `canPlayOneShotSound` | `self, ruid, soundCategory` | client | 1-78 |
| `SoundUtils` | `clearCashStickerHitSoundComponentPoolLocal` | `self` | client | 1-20 |
| `SoundUtils` | `ensureCashStickerHitSoundComponentPoolLocal` | `self, ruid, source, volume` | client | 1-58 |
| `SoundUtils` | `ensureSoundCategoryState` | `self, state` | client | 1-42 |
| `SoundUtils` | `get_sound_volume_by_pos` | `self, x, y` | client | 1-20 |
| `SoundUtils` | `getActiveCashStickerHitSoundCountLocal` | `self` | client | 1-22 |
| `SoundUtils` | `getSoundGuardState` | `self` | client | 1-14 |
| `SoundUtils` | `normalizeSoundCategory` | `self, soundCategory` | client | 1-13 |
| `SoundUtils` | `playCashStickerHitSoundByComponentPoolLocal` | `self, ruid, source, volume` | client | 1-27 |
| `SoundUtils` | `playLoopSoundLocal` | `self, ruid, volume, loopCategory` | client | 1-27 |
| `SoundUtils` | `playOneShotSoundAtPosLocal` | `self, ruid, pos, listener, volume, soundCategory` | client | 1-8 |
| `SoundUtils` | `playOneShotSoundLocal` | `self, ruid, volume, soundCategory` | client | 1-7 |
| `SoundUtils` | `playPlayerSkillSoundAtPosLocal` | `self, path, speaker, volume` | client | 1-10 |
| `SoundUtils` | `playSkillSoundLocal` | `self, speacker, skillId` | client | 1-4 |
| `SoundUtils` | `playSoundLocal` | `self, speaker, imgName, l1, l2` | client | 1-17 |
| `SoundUtils` | `resolveCombatSoundCategory` | `self, speaker` | client | 1-10 |
| `SoundUtils` | `resolveSkillSoundRefId` | `self, skillId` | client | 1-28 |
| `SoundUtils` | `shouldPlayDropSound` | `self, sourceID` | client | 1-10 |
| `SoundUtils` | `shouldPlayOtherPlayerSkillSound` | `self, speaker` | client | 1-10 |
| `SoundUtils` | `stopLoopSoundLocal` | `self, ruid` | client | 1-19 |
| `StackMessageLogic` | `addMessage` | `self, message` | client | 1-63 |
| `StackMessageLogic` | `addMessage_bitmap` | `self, message, color` | client | 1-114 |
| `StackMessageLogic` | `applyStackMessageEntityLayout` | `self, entity, positionY` | client | 1-20 |
| `StackMessageLogic` | `OnBeginPlay` | `self` | client | 1-23 |
| `StackMessageLogic` | `OnMapLeave` | `self, player` | client | 1-6 |
| `StackMessageLogic` | `resetMessagePool` | `self` | client | 1-43 |
| `StorageLogic` | `allocSlotId` | `self, storage` | server-only | 1-5 |
| `StorageLogic` | `clearUserStorage` | `self, user` | server-only | 1-10 |
| `StorageLogic` | `clearUserStorageByOwnerId` | `self, ownerId` | server-only | 1-7 |
| `StorageLogic` | `cloneStorageEquipInfo` | `self, equipInfo` | server-only | 1-18 |
| `StorageLogic` | `cloneTable` | `self, src` | server-only | 1-19 |
| `StorageLogic` | `createEmptyStorageData` | `self` | server-only | 1-13 |
| `StorageLogic` | `deserializeStorage` | `self, raw` | server-only | 1-44 |
| `StorageLogic` | `ensureUserStorage` | `self, user` | server-only | 1-10 |
| `StorageLogic` | `ensureUserStorageByOwnerId` | `self, ownerId` | server-only | 1-47 |
| `StorageLogic` | `getInvTypeByItemId` | `self, itemId` | server-only | 1-7 |
| `StorageLogic` | `getLegacyStorageTableName` | `self, id` | server-only | 1-6 |
| `StorageLogic` | `getStorageCapacity` | `self, invType` | server-only | 1-6 |
| `StorageLogic` | `getStorageListByUser` | `self, user, invType` | server-only | 1-33 |
| `StorageLogic` | `getStorageMesoByUser` | `self, user` | server-only | 1-7 |
| `StorageLogic` | `getStorageOwnerId` | `self, user` | server-only | 1-16 |
| `StorageLogic` | `getStoragePutFee` | `self` | server-only | 1-3 |
| `StorageLogic` | `getStorageTableName` | `self, ownerId` | server-only | 1-6 |
| `StorageLogic` | `isOnlyItem` | `self, item, equipInfo` | server-only | 1-10 |
| `StorageLogic` | `isSameStorageItemMeta` | `self, a, b` | server-only | 1-24 |
| `StorageLogic` | `isStorageDataEmpty` | `self, storage` | server-only | 1-19 |
| `StorageLogic` | `isTradeBlockedOrQuestItem` | `self, item, equipInfo` | server-only | 1-18 |
| `StorageLogic` | `loadStorageByUserData` | `self, user, raw` | server-only | 1-11 |
| `StorageLogic` | `makeStorageItemStack` | `self, invType, slotId, itemId, count, equipInfo` | server-only | 1-9 |
| `StorageLogic` | `normalizeStoragePutEquipInfo` | `self, equipInfo, isCash` | server-only | 1-18 |
| `StorageLogic` | `openStorageUIClient` | `self, userId, npcId` | server-only | 1-11 |
| `StorageLogic` | `preloadUserStorage` | `self, user` | server-only | 1-3 |
| `StorageLogic` | `reindexStorageSlotIds` | `self, storage` | server-only | 1-45 |
| `StorageLogic` | `saveUserStorageByOwnerId` | `self, ownerId` | server-only | 1-16 |
| `StorageLogic` | `serializeStorage` | `self, storage` | server-only | 1-48 |
| `StorageLogic` | `serializeStorageByUser` | `self, user` | server-only | 1-8 |
| `StorageLogic` | `serializeStorageEquipInfo` | `self, equipInfo` | server-only | 1-14 |
| `StorageLogic` | `serializeStorageItemStack` | `self, stack` | server-only | 1-12 |
| `StorageLogic` | `toJsonSafeTable` | `self, src` | server-only | 1-24 |
| `StorageLogic` | `tryDepositMesoByUser` | `self, user, amount` | server-only | 1-30 |
| `StorageLogic` | `tryPutItemByUser` | `self, user, invType, slot, count` | server-only | 1-193 |
| `StorageLogic` | `tryTakeItemByUser` | `self, user, invType, slotId, count` | server-only | 1-108 |
| `StorageLogic` | `tryWithdrawMesoByUser` | `self, user, amount` | server-only | 1-28 |
| `StringPoolManager` | `findNameByString` | `self, typeName, keyword` | client | 1-46 |
| `StringPoolManager` | `getItemName` | `self, itemID` | client | 1-24 |
| `StringPoolManager` | `getMapCategoryById` | `self, mapId` | client | 1-24 |
| `StringPoolManager` | `getMapName` | `self, mapID` | client | 1-6 |
| `StringPoolManager` | `getMobName` | `self, mobID` | client | 1-3 |
| `StringPoolManager` | `getSkillName` | `self, skillID` | client | 1-3 |
| `StringPoolManager` | `getStringPool` | `self, path` | client | 1-27 |
| `StringPoolManager` | `getStringPoolTable` | `self, path` | client | 1-27 |
| `StringPoolManager` | `getToolTipDesc` | `self, mapID, toolTipID` | client | 1-3 |
| `StringPoolManager` | `getToolTipTitle` | `self, mapID, toolTipID` | client | 1-3 |
| `StringPoolManager` | `loadStringPool` | `self` | client | 1-78 |
| `SummonAction` | `castKeyFromIndex` | `self, i` | client | 1-3 |
| `SummonAction` | `OnBeginPlay` | `self` | client | 1-22 |
| `SummonAssistType` | `castFrom` | `self, skillID` | server-only | 1-3 |
| `SummonAssistType` | `OnBeginPlay` | `self` | server-only | 1-28 |
| `SummonMoveAbility` | `castFrom` | `self, skillID` | server-only | 1-3 |
| `SummonMoveAbility` | `OnBeginPlay` | `self` | server-only | 1-33 |
| `SummonedPacket` | `attack` | `self, t` | client | 1-20 |
| `SummonedPacket` | `beholdersEffect` | `self, t` | client | 1-14 |
| `SummonedPacket` | `DoBeholdersBuff` | `self, summon, type` | server-only | 1-62 |
| `SummonedPacket` | `DoBeholdersHealing` | `self, summon` | server-only | 1-41 |
| `SummonedPacket` | `enterField` | `self, map, summon, targetUser, initialAttackAble` | server-only | 1-15 |
| `SummonedPacket` | `enterField_ToClient` | `self, t` | client | 1-29 |
| `SummonedPacket` | `forceRemove_ToClient` | `self, dwSummonedID, leaveType` | client | 1-7 |
| `SummonedPacket` | `getObservedUser_Client` | `self` | client | 1-19 |
| `SummonedPacket` | `getSummon_Client` | `self, dwSummonedID` | client | 1-17 |
| `SummonedPacket` | `getSummonFromMap_Client` | `self, map, dwSummonedID` | client | 1-10 |
| `SummonedPacket` | `hit` | `self, t` | client | 1-20 |
| `SummonedPacket` | `leaveField` | `self, map, summon` | server-only | 1-10 |
| `SummonedPacket` | `leaveField_ToClient` | `self, dwSummonedID, leaveType` | client | 1-9 |
| `SummonedPacket` | `move` | `self, t` | client | 1-19 |
| `SummonedPacket` | `onAttack` | `self, t, senderUserId` | server-only | 1-85 |
| `SummonedPacket` | `onBeholdersBuff` | `self, t, senderUserId` | server-only | 1-35 |
| `SummonedPacket` | `onCheckRemove` | `self, dwSummonedID, leaveType, senderUserId` | server-only | 1-22 |
| `SummonedPacket` | `onHit` | `self, t, senderUserId` | server-only | 1-32 |
| `SummonedPacket` | `onMove` | `self, t, senderUserId` | server-only | 1-42 |
| `Surgery` | `applyRandomSurgery` | `self, player, udc, scriptName, mode, itemList` | server-only | 1-19 |
| `Surgery` | `applySelectedSurgery` | `self, selectedIndex, mode, scriptName, senderUserId` | server-only | 1-39 |
| `Surgery` | `applySelectedSurgeryLookClient` | `self, targetUser, itemId, mode` | client | 1-48 |
| `Surgery` | `applySelectedSurgeryToPreviewClient` | `self` | client | 1-37 |
| `Surgery` | `applySurgeryItemServer` | `self, user, itemId, mode, scriptName` | server-only | 1-32 |
| `Surgery` | `applySurgeryTakeoffPreviewClient` | `self, costume, user` | client | 1-38 |
| `Surgery` | `buildFaceList` | `self, player, config` | server-only | 1-19 |
| `Surgery` | `buildHairColorList` | `self, player, config` | server-only | 1-13 |
| `Surgery` | `buildHairStyleList` | `self, player, config` | server-only | 1-26 |
| `Surgery` | `buildSkinList` | `self, config` | server-only | 1-7 |
| `Surgery` | `buildSurgeryItemList` | `self, player, scriptName, mode` | server-only | 1-23 |
| `Surgery` | `cacheScriptFunc` | `self` | server-only | 1-17 |
| `Surgery` | `clearSurgerySession` | `self, player` | server-only | 1-9 |
| `Surgery` | `closeSurgeryUIClient` | `self` | client | 1-5 |
| `Surgery` | `ensureSurgeryUIClient` | `self` | client | 1-59 |
| `Surgery` | `excludeCurrentSurgeryItems` | `self, player, mode, itemList` | server-only | 1-15 |
| `Surgery` | `filterAvailableSurgeryItems` | `self, category, itemList` | server-only | 1-10 |
| `Surgery` | `getSkinBodyRuid` | `self, skin` | client | 1-11 |
| `Surgery` | `getSurgeryConfig` | `self, scriptName` | server-only | 1-453 |
| `Surgery` | `getSurgeryCouponItemId` | `self, scriptName, mode` | server-only | 1-11 |
| `Surgery` | `getSurgeryCurrentItemId` | `self, player, mode` | server-only | 1-13 |
| `Surgery` | `getSurgeryDescription` | `self, scriptName, mode` | server-only | 1-10 |
| `Surgery` | `getSurgeryItemNameClient` | `self, mode, itemId` | client | 1-16 |
| `Surgery` | `getSurgeryLackCouponMessage` | `self, scriptName, mode` | server-only | 1-10 |
| `Surgery` | `getSurgerySession` | `self, player` | server-only | 1-9 |
| `Surgery` | `getSurgerySuccessMessage` | `self, scriptName, mode` | server-only | 1-10 |
| `Surgery` | `isCurrentSurgeryItem` | `self, player, mode, itemId` | server-only | 1-4 |
| `Surgery` | `isSurgeryItemAvailable` | `self, category, itemId` | server-only | 1-27 |
| `Surgery` | `onClickSurgeryNextClient` | `self` | client | 1-8 |
| `Surgery` | `onClickSurgeryOkClient` | `self` | client | 1-11 |
| `Surgery` | `onClickSurgeryPrevClient` | `self` | client | 1-8 |
| `Surgery` | `onClickSurgeryTakeoffClient` | `self` | client | 1-5 |
| `Surgery` | `openSurgerySelectUI` | `self, player, udc, scriptName, mode, itemList` | server-only | 1-18 |
| `Surgery` | `openSurgeryUIClient` | `self, scriptName, mode, itemList, description, npcId` | client | 1-23 |
| `Surgery` | `rebuildSurgeryPreviewBaseClient` | `self` | client | 1-49 |
| `Surgery` | `refreshSurgeryLookClient` | `self, targetUser` | client | 1-12 |
| `Surgery` | `refreshSurgeryLookForMap` | `self, targetUser` | server-only | 1-16 |
| `Surgery` | `refreshSurgeryNpcClient` | `self` | client | 1-31 |
| `Surgery` | `refreshSurgeryPreviewClient` | `self` | client | 1-29 |
| `Surgery` | `saveSurgerySession` | `self, player, scriptName, mode, itemList` | server-only | 1-16 |
| `Surgery` | `setSurgeryTextClient` | `self, target, text` | client | 1-13 |
| `Surgery` | `Surgery` | `self, player, udc, scriptName` | server-only | 1-81 |
| `TableUtils` | `clone` | `self, t` | client | 1-5 |
| `TableUtils` | `deepCopy` | `self, t, seen` | client | 1-13 |
| `TableUtils` | `get_random_unique_array` | `self, start, range, count` | client | 1-26 |
| `TableUtils` | `isContains` | `self, t, obj` | client | 1-8 |
| `TableUtils` | `len` | `self, t` | client | 1-5 |
| `TableUtils` | `shuffle` | `self, t` | client | 1-6 |
| `TableUtils` | `spairs` | `self, tbl` | client | 1-13 |
| `TableUtils` | `unique` | `self, t` | client | 1-11 |
| `TamingMobManager` | `getCharacterTamingMob` | `self, tamingMobId, motion` | client | 1-22 |
| `TamingMobManager` | `getCharacterTamingMobNodeByPath` | `self, path` | client | 1-34 |
| `TamingMobManager` | `getCharacterTamingMobRUID` | `self, tamingMobId, motion, frameIndex, layerIndex` | client | 1-4 |
| `TamingMobManager` | `getCharacterTamingMobRUIDByPath` | `self, path` | client | 1-11 |
| `TamingMobManager` | `getCharacterTamingMobSaddle` | `self, tamingMobId, motion` | client | 1-30 |
| `TamingMobManager` | `getLinkedTamingMobData` | `self, characterTamingMobId` | client | 1-7 |
| `TamingMobManager` | `getLinkedTamingMobId` | `self, characterTamingMobId` | client | 1-11 |
| `TamingMobManager` | `getTamingMob` | `self, tamingMobId` | client | 1-3 |
| `TamingMobManager` | `getTamingMobData` | `self, tamingMobId` | client | 1-7 |
| `TamingMobManager` | `loadTamingMob` | `self` | client | 1-41 |
| `TamingMobManager` | `parseCharacterTamingMobMotion` | `self, tamingMobId, motion, rawMotion, isSaddle, ruidSourceId` | client | 1-187 |
| `Taxi` | `aqua_taxi` | `self, player, udc` | server-only | 1-74 |
| `Taxi` | `aqua_taxi2` | `self, player, udc` | server-only | 1-17 |
| `Taxi` | `aqua_taxi3` | `self, player, udc` | server-only | 1-9 |
| `Taxi` | `cacheScriptFunc` | `self` | server-only | 1-38 |
| `Taxi` | `crane` | `self, player, udc` | server-only | 1-76 |
| `Taxi` | `mTaxi` | `self, player, udc` | server-only | 1-37 |
| `Taxi` | `nihal_taxi` | `self, player, udc` | server-only | 1-29 |
| `Taxi` | `ossyria_taxi` | `self, player, udc` | server-only | 1-38 |
| `Taxi` | `victoria_taxi` | `self, player, udc` | server-only | 1-158 |
| `TestScript` | `cacheScriptFunc` | `self` | server-only | 1-5 |
| `TestScript` | `testScript` | `self, udc` | server-only | 1-30 |
| `TestScript` | `testScript2` | `self, udc` | server-only | 1-4 |
| `ThiefLogic` | `playerHideAndShow` | `self, player, interval` | client | 1-4 |
| `ThiefLogic` | `playerHideAndShowLocal` | `self, player, interval` | client | 1-6 |
| `ThiefLogic` | `playerHideAndShowRemote` | `self, player, interval, senderUserId` | server-only | 1-16 |
| `TimedSkillLogic` | `applyTimedRidingSkill` | `self, user, skillType, durationMilliseconds` | server-only | 1-66 |
| `TimedSkillLogic` | `applyTimedRidingSkillDays` | `self, user, skillType, days` | server-only | 1-4 |
| `TimedSkillLogic` | `applyTimedRidingSkillHours` | `self, user, skillType, hours` | server-only | 1-4 |
| `TimedSkillLogic` | `applyTimedRidingSkillMinutes` | `self, user, skillType, minutes` | server-only | 1-4 |
| `TimedSkillLogic` | `applyTimedRidingSkillSeconds` | `self, user, skillType, seconds` | server-only | 1-4 |
| `TimedSkillLogic` | `applyTimedSkillCoupon` | `self, user, itemId` | server-only | 1-10 |
| `TimedSkillLogic` | `canUseTimedSkillCoupon` | `self, user, itemId` | server-only | 1-26 |
| `TimedSkillLogic` | `getCouponDays` | `self, itemId` | client | 1-13 |
| `TimedSkillLogic` | `getCouponSkillType` | `self, itemId` | client | 1-19 |
| `TimedSkillLogic` | `getDayMilliseconds` | `self` | client | 1-4 |
| `TimedSkillLogic` | `getHourMilliseconds` | `self` | client | 1-4 |
| `TimedSkillLogic` | `getMaxDaysBySkillId` | `self, skillId` | client | 1-15 |
| `TimedSkillLogic` | `getMaxDaysBySkillType` | `self, skillType` | client | 1-8 |
| `TimedSkillLogic` | `getMinuteMilliseconds` | `self` | client | 1-4 |
| `TimedSkillLogic` | `getNow` | `self` | client | 1-3 |
| `TimedSkillLogic` | `getRidingSkillIdByJob` | `self, user, skillType` | client | 1-53 |
| `TimedSkillLogic` | `getSecondMilliseconds` | `self` | client | 1-4 |
| `TimedSkillLogic` | `getSkillIdByCoupon` | `self, user, itemId` | client | 1-9 |
| `TimedSkillLogic` | `getTimedSkillExpireAtText` | `self, expireAt` | server-only | 1-5 |
| `TimedSkillLogic` | `getTimedSkillName` | `self, skillId` | server-only | 1-7 |
| `TimedSkillLogic` | `hasActiveTimedSkillCoupon` | `self, user, itemId` | server-only | 1-18 |
| `TimedSkillLogic` | `isRegisteredTimedSkill` | `self, skillId` | server-only | 1-3 |
| `TimedSkillLogic` | `isTimedSkillCoupon` | `self, itemId` | client | 1-3 |
| `TimedSkillLogic` | `normalizeRidingSkillType` | `self, skillType` | client | 1-22 |
| `TimedSkillLogic` | `notifyTimedSkillApplied` | `self, user, skillId, expireAt, maxDays, extended` | server-only | 1-15 |
| `TimedSkillLogic` | `notifyTimedSkillCouponApplied` | `self, user, itemId, extended` | server-only | 1-23 |
| `TimedSkillLogic` | `notifyTimedSkillExpired` | `self, user, skillId` | server-only | 1-16 |
| `TimedSkillLogic` | `removeExpiredTimedSkills` | `self, user` | server-only | 1-42 |
| `TimedSkillLogic` | `removeTimedSkill` | `self, user, skillId` | server-only | 1-13 |
| `TooltipManager` | `showEquipTooltip` | `self, itemId, ieqp, subItemID, subEqp` | client | 1-41 |
| `TownPortalPacket` | `enterField` | `self, map, door, enterType, targetUser` | server-only | 1-13 |
| `TownPortalPacket` | `enterField_ToClient` | `self, ownerID, pos, enterType` | client | 1-17 |
| `TownPortalPacket` | `leaveField` | `self, map, door, leaveType, targetUser` | server-only | 1-13 |
| `TownPortalPacket` | `leaveField_ToClient` | `self, ownerID, leaveType` | client | 1-10 |
| `TownPortalPacket` | `tryEnterTownPortal` | `self, isTown, ownerID, senderUserId` | server-only | 1-71 |
| `TradingLogic` | `acceptedOtherClient` | `self` | client | 1-16 |
| `TradingLogic` | `applyTradingUIPositions` | `self` | client | 1-13 |
| `TradingLogic` | `canReceiveTradeOnlyItems` | `self, receiver, tradeItems` | server-only | 1-28 |
| `TradingLogic` | `chatClient` | `self, senderIsMe, text` | client | 1-6 |
| `TradingLogic` | `createTradingRoomClient` | `self` | client | 1-15 |
| `TradingLogic` | `doTrade` | `self, user1, user2` | server-only | 1-164 |
| `TradingLogic` | `getValidTradeOther` | `self, user` | server-only | 1-22 |
| `TradingLogic` | `hasExpiredTradeItem` | `self, tradeItems` | server-only | 1-11 |
| `TradingLogic` | `hasExpireSoonTradeItem` | `self, tradeItems` | server-only | 1-11 |
| `TradingLogic` | `invitedTradeClient` | `self, inviterName` | client | 1-8 |
| `TradingLogic` | `inviteTrade` | `self, name` | client | 1-28 |
| `TradingLogic` | `inviteTradeToServer` | `self, name, senderUserId` | server-only | 1-89 |
| `TradingLogic` | `isOnlyItem` | `self, itemId` | server-only | 1-9 |
| `TradingLogic` | `isTradeItemExpired` | `self, itemStack` | server-only | 1-15 |
| `TradingLogic` | `isTradeItemExpireSoon` | `self, itemStack` | server-only | 1-19 |
| `TradingLogic` | `isTradePetItem` | `self, itemStack` | server-only | 1-8 |
| `TradingLogic` | `leaveTrade` | `self, user, type, meso` | server-only | 1-52 |
| `TradingLogic` | `leaveTradingRoomClient` | `self, msgType, meso` | client | 1-37 |
| `TradingLogic` | `makeTradeSessionId` | `self` | server-only | 1-6 |
| `TradingLogic` | `resetTradeInvitePendingClient` | `self` | client | 1-9 |
| `TradingLogic` | `setItemClient` | `self, other, tdSlot, itemStack` | client | 1-6 |
| `TradingLogic` | `setMesoClient` | `self, other, meso` | client | 1-6 |
| `TradingLogic` | `setTradeOK` | `self, other` | client | 1-6 |
| `TradingLogic` | `tradingFee` | `self, meso` | client | 1-7 |
| `TradingLogic` | `tryAcceptTrade` | `self, ok, senderUserId` | server-only | 1-59 |
| `TradingLogic` | `tryAddMeso` | `self, meso, senderUserId` | server-only | 1-40 |
| `TradingLogic` | `tryChat` | `self, text, senderUserId` | server-only | 1-35 |
| `TradingLogic` | `tryLeaveTrade` | `self, senderUserId` | server-only | 1-26 |
| `TradingLogic` | `trySetItem` | `self, invType, invSlot, tdSlot, count, senderUserId` | server-only | 1-104 |
| `TradingLogic` | `tryTradeOK` | `self, senderUserId` | server-only | 1-67 |
| `UIElementLogic` | `cloneMoveToMouse` | `self` | client | 1-7 |
| `UIElementLogic` | `disableClone` | `self` | client | 1-23 |
| `UIElementLogic` | `enableClone` | `self, clickedEntity, RUID, size` | client | 1-33 |
| `UIElementLogic` | `OnBeginPlay` | `self` | client | 1-4 |
| `UIItemTooltip` | `buildItemTooltipExpireText` | `self, itemId, ieqp` | client | 1-28 |
| `UIItemTooltip` | `buildItemTooltipFlagLayout` | `self, ieqp` | client | 1-65 |
| `UIItemTooltip` | `buildSkillTooltipExpireText` | `self, skillId` | client | 1-22 |
| `UIItemTooltip` | `createGuildBuffSkillTooltipUI` | `self, skillName, skillDesc, iconRUID, fixedWidth` | client | 1-176 |
| `UIItemTooltip` | `createInfoTooltipUI` | `self, titleStr, descStr, fixedWidth` | client | 1-184 |
| `UIItemTooltip` | `createItemTooltipUI` | `self, itemId, ieqp` | client | 1-318 |
| `UIItemTooltip` | `createSkillTooltipUI` | `self, skillId, skillLevel` | client | 1-266 |
| `UIItemTooltip` | `createTextTooltipUI` | `self, text, maxWidth` | client | 1-98 |
| `UIItemTooltip` | `getBaseEntity` | `self, dir, name` | client | 1-3 |
| `UIItemTooltip` | `getEquipOptionsText` | `self, equip, equipInfo` | client | 1-59 |
| `UIItemTooltip` | `getGrowthRUID` | `self, name, enabled` | client | 1-9 |
| `UIItemTooltip` | `getItemTooltipDescBodyHeight` | `self, fontComp, layoutInfo` | client | 1-15 |
| `UIItemTooltip` | `getItemTooltipStatusLayout` | `self, hasFlag, hasFlagLine2, hasExpTime` | client | 1-36 |
| `UIItemTooltip` | `getRequireRUID` | `self, name, can` | client | 1-9 |
| `UIItemTooltip` | `getSizeGrowthRUID` | `self, name, enabled` | client | 1-9 |
| `UIItemTooltip` | `getSizeRequireRUID` | `self, name, can` | client | 1-9 |
| `UIItemTooltip` | `getSkillLevelText` | `self, skillId, skillLevel, masterLevel` | client | 1-20 |
| `UIItemTooltip` | `isPotentialResetBlockedRewardEquip` | `self, itemId` | client | 1-4 |
| `UIItemTooltip` | `OnBeginPlay` | `self` | client | 1-82 |
| `UIItemTooltip` | `refreshSkillTooltipDivider` | `self, base` | client | 1-27 |
| `UIItemTooltip` | `refreshSkillTooltipDividerDeferred` | `self, base` | client | 1-12 |
| `UIItemTooltip` | `renderDigitSprite` | `self, reqName, value, can, startPos, parent` | client | 1-46 |
| `UIItemTooltip` | `renderRequireJob` | `self, parent, reqJob` | client | 1-40 |
| `UIItemTooltip` | `renderRequireValues` | `self, parent, equipInfo` | client | 1-77 |
| `UILoading` | `cancelMapFadeWatchdog` | `self` | client | 1-14 |
| `UILoading` | `clearDataLoadDetailText` | `self` | client | 1-3 |
| `UILoading` | `completedDataLoading` | `self` | client | 1-50 |
| `UILoading` | `completePlanetFadeInState` | `self` | client | 1-42 |
| `UILoading` | `ensureLoginCamera` | `self` | client | 1-27 |
| `UILoading` | `HandleFadeInStartEvent` | `self, event` | client | 1-3 |
| `UILoading` | `HandleFadeOutStartEvent` | `self, event` | client | 1-10 |
| `UILoading` | `initLoading` | `self` | client | 1-9 |
| `UILoading` | `loadingFadeIn` | `self, duration, delay, fromLogin` | client | 1-72 |
| `UILoading` | `loadingFadeOut` | `self, duration, fadeInCallback` | client | 1-39 |
| `UILoading` | `OnEndPlay` | `self` | client | 1-3 |
| `UILoading` | `planetFadeIn` | `self, delay, duration` | client | 1-87 |
| `UILoading` | `planetFadeOut` | `self` | client | 1-13 |
| `UILoading` | `recoverMapFadeAfterTimeout` | `self` | client | 1-78 |
| `UILoading` | `reportMapFadeWatchdog` | `self, text` | client | 1-17 |
| `UILoading` | `scheduleMapFadeWatchdog` | `self, delay` | client | 1-14 |
| `UILoading` | `setDataLoadDetailText` | `self, text` | client | 1-8 |
| `UILoading` | `setDataLoading` | `self` | client | 1-3 |
| `UILoading` | `setIsWarp` | `self, warp` | client | 1-3 |
| `UILoading` | `setMapFadeExpectedMapId` | `self, mapId, token` | client | 1-9 |
| `UILoading` | `startMapFadeWatchdog` | `self` | client | 1-33 |
| `UILoading` | `updateLoadText` | `self, cur` | client | 1-7 |
| `UIManager` | `buildImageSizeCache` | `self` | client | 1-6 |
| `UIManager` | `collectImageSize` | `self, node` | client | 1-18 |
| `UIManager` | `getChatBalloon` | `self, path` | client | 1-16 |
| `UIManager` | `getImage` | `self, path` | client | 1-20 |
| `UIManager` | `getImageSize` | `self, imageKey` | client | 1-3 |
| `UIManager` | `getImageSizeByPath` | `self, path` | client | 1-7 |
| `UIManager` | `getMobGage` | `self, mobID` | client | 1-3 |
| `UIManager` | `getNameTag` | `self, path` | client | 1-16 |
| `UIManager` | `getNode` | `self, path` | client | 1-14 |
| `UIManager` | `getRUID` | `self, path` | client | 1-10 |
| `UIManager` | `loadUI` | `self` | client | 1-36 |
| `UIManager` | `parseChatBalloon` | `self, node` | client | 1-33 |
| `UIManager` | `parseChatBalloonFrame` | `self, node, clr` | client | 1-39 |
| `UIManager` | `parseDefaultNameTag` | `self` | client | 1-20 |
| `UIManager` | `parseNameTag` | `self, node` | client | 1-30 |
| `UIMiniMap` | `applyIconStyle` | `self, iconEntity, type` | client | 1-44 |
| `UIMiniMap` | `arrangeMiniMapLayerBeforeMobileChat` | `self` | client | 1-20 |
| `UIMiniMap` | `attachMiniMapWindowToUIGroup` | `self, miniMapWindow, tempGroup, uiGroup` | client | 1-13 |
| `UIMiniMap` | `calculateHeightOffset` | `self, baseHeight` | client | 1-8 |
| `UIMiniMap` | `calculateNameWidth` | `self, text` | client | 1-3 |
| `UIMiniMap` | `canShowTargetIcon` | `self, localPlayer, target` | client | 1-27 |
| `UIMiniMap` | `clamp` | `self, value, min, max` | client | 1-3 |
| `UIMiniMap` | `clearMapScopedIcons` | `self` | client | 1-10 |
| `UIMiniMap` | `clearMapScopedIconsFromCanvas` | `self, canvas` | client | 1-23 |
| `UIMiniMap` | `createMiniMap` | `self` | client | 1-614 |
| `UIMiniMap` | `createNpcIcon` | `self` | client | 1-94 |
| `UIMiniMap` | `createOrUpdateTargetIcon` | `self, userId, type, pos` | client | 1-13 |
| `UIMiniMap` | `createOrUpdateTargetIconInCanvas` | `self, userId, type, pos, canvas` | client | 1-13 |
| `UIMiniMap` | `createPortalIcon` | `self` | client | 1-64 |
| `UIMiniMap` | `createTargetIcon` | `self, userId, pos` | client | 1-16 |
| `UIMiniMap` | `destroyStaleTargetIcons` | `self, canvas, activeUserIds` | client | 1-27 |
| `UIMiniMap` | `destroyTargetIcon` | `self, userId` | client | 1-15 |
| `UIMiniMap` | `getAnchoredPos` | `self, canvasSize, spriteSize` | client | 1-7 |
| `UIMiniMap` | `getFriendGroup` | `self` | client | 1-12 |
| `UIMiniMap` | `getMiniMapPlayer` | `self` | client | 1-19 |
| `UIMiniMap` | `getTargetIconType` | `self, userEntity` | client | 1-49 |
| `UIMiniMap` | `OnBeginPlay` | `self` | client | 1-79 |
| `UIMiniMap` | `onClickBtnMax` | `self` | client | 1-5 |
| `UIMiniMap` | `onClickBtnMin` | `self` | client | 1-5 |
| `UIMiniMap` | `onClickBtnWorld` | `self` | client | 1-3 |
| `UIMiniMap` | `onMinimapKey` | `self` | client | 1-5 |
| `UIMiniMap` | `OnUpdate` | `self, delta` | client | 1-61 |
| `UIMiniMap` | `onUpdateIcon` | `self` | client | 1-57 |
| `UIMiniMap` | `refreshMiniMap` | `self` | client | 1-197 |
| `UIMiniMap` | `refreshQuestConditionNpcIcons` | `self` | client | 1-41 |
| `UIMiniMap` | `resizeMiniMapWindow` | `self, window, centerSize` | client | 1-23 |
| `UIMiniMap` | `switchMiniMapUI` | `self, nextType, fromUI, toUI, offsetX, offsetY` | client | 1-17 |
| `UIMiniMap` | `tripTo40Bytes` | `self, str` | client | 1-15 |
| `UIMiniMap` | `updateMiniMapCanvas` | `self, canvas, ruid, spriteSize, viewportSize` | client | 1-27 |
| `UIMiniMap` | `updateNpcIcon` | `self, npcID, questState` | client | 1-18 |
| `UIMiniMap` | `updateTargetIcon` | `self, userId` | client | 1-11 |
| `UIMiniMap` | `updateTargetIconByType` | `self, userId, type` | client | 1-9 |
| `UIMiniMap` | `worldToMiniMap` | `self, worldPos` | client | 1-71 |
| `UIMobileHudLayout` | `applyMobileActionSlotsLayout` | `self, openX, openY, hiddenOffsetX` | client | 1-8 |
| `UIMobileHudLayout` | `applyMobileChatBoardLayout` | `self, visibleRect, layoutRect, boardWidth, boardHeight, boardScale` | client | 1-25 |
| `UIMobileHudLayout` | `applyMobileChatPosition` | `self, defaultY` | client | 1-17 |
| `UIMobileHudLayout` | `ApplyMobileHudLayout` | `self` | client | 1-67 |
| `UIMobileHudLayout` | `ApplyMobileHudLayoutDeferred` | `self` | client | 1-11 |
| `UIMobileHudLayout` | `applyMobileMenuLayout` | `self, visibleRect, layoutRect, panelWidth, panelHeight, panelScale` | client | 1-24 |
| `UIMobileHudLayout` | `applyMobileStackMessageLayout` | `self, visibleRect, layoutRect` | client | 1-28 |
| `UIMobileHudLayout` | `applyTarget` | `self, path, offsetX, offsetY` | client | 1-12 |
| `UIMobileHudLayout` | `applyTargetToBasePosition` | `self, targetPath, sourcePath, offsetX, offsetY` | client | 1-9 |
| `UIMobileHudLayout` | `FitMobileChatPositionInBounds` | `self` | client | 1-58 |
| `UIMobileHudLayout` | `FitMobileTooltipPositionInBounds` | `self, positionX, positionY, tooltipWidth, tooltipHeight, rightMargin` | client | 1-29 |
| `UIMobileHudLayout` | `getBasePosition` | `self, path, transform` | client | 1-11 |
| `UIMobileHudLayout` | `getBaseSize` | `self, path, transform` | client | 1-11 |
| `UIMobileHudLayout` | `getCurrentAspect` | `self` | client | 1-14 |
| `UIMobileHudLayout` | `getCurrentMobileLayoutRect` | `self` | client | 1-4 |
| `UIMobileHudLayout` | `getDefinedBasePosition` | `self, path, transform` | client | 1-40 |
| `UIMobileHudLayout` | `getDefinedBaseSize` | `self, path, transform` | client | 1-22 |
| `UIMobileHudLayout` | `getEstimatedMobileLayoutRect` | `self, visibleRect` | client | 1-20 |
| `UIMobileHudLayout` | `getFitScale` | `self, baseWidth, baseHeight, targetWidth, targetHeight, minScale, maxScale` | client | 1-6 |
| `UIMobileHudLayout` | `getMobileActionSlotSettingLayoutX` | `self, actionSlotToggleX` | client | 1-3 |
| `UIMobileHudLayout` | `getMobileActionSlotsHiddenOffsetX` | `self, visibleRect, layoutRect` | client | 1-4 |
| `UIMobileHudLayout` | `getMobileActionSlotsLayoutX` | `self, visibleRect, layoutRect, tabletWeight` | client | 1-5 |
| `UIMobileHudLayout` | `getMobileActionSlotsLayoutY` | `self, visibleRect, layoutRect, tabletWeight` | client | 1-5 |
| `UIMobileHudLayout` | `GetMobileChatDefaultY` | `self` | client | 1-6 |
| `UIMobileHudLayout` | `GetMobileChatPositionData` | `self` | client | 1-7 |
| `UIMobileHudLayout` | `getMobileShortcutLayoutX` | `self, visibleRect, layoutRect` | client | 1-16 |
| `UIMobileHudLayout` | `getMobileStatusBarRect` | `self` | client | 1-12 |
| `UIMobileHudLayout` | `getMobileVisibleRect` | `self` | client | 1-41 |
| `UIMobileHudLayout` | `getTabletWeight` | `self` | client | 1-10 |
| `UIMobileHudLayout` | `getWideWeight` | `self` | client | 1-10 |
| `UIMobileHudLayout` | `IsMobileChatPositionInBounds` | `self, positionX, positionY` | client | 1-35 |
| `UIMobileHudLayout` | `prepareBasePositions` | `self` | client | 1-5 |
| `UIMobileHudLayout` | `prepareBaseSizes` | `self` | client | 1-5 |
| `UIMobileHudLayout` | `RefreshMobileChatBoardLayout` | `self` | client | 1-15 |
| `UIMobileHudLayout` | `ResetMobileChatPosition` | `self` | client | 1-12 |
| `UIMobileHudLayout` | `RestoreMobileChatPosition` | `self, saved, positionX, positionY` | client | 1-23 |
| `UIMobileHudLayout` | `setTargetPosition` | `self, path, x, y` | client | 1-9 |
| `UIMobileHudLayout` | `setTargetSize` | `self, path, width, height` | client | 1-9 |
| `UIMobileHudLayout` | `SyncMobileChatPositionToServer` | `self` | client | 1-13 |
| `UIMobileHudLayout` | `TrySetMobileChatPosition` | `self, positionX, positionY` | client | 1-24 |
| `UIMobileJoystickLogic` | `clearMobileNpcTouchCandidate` | `self` | client | 1-7 |
| `UIMobileJoystickLogic` | `connectMobileNpcTouchCorrection` | `self` | client | 1-13 |
| `UIMobileJoystickLogic` | `findMobileNpcAtScreenPoint` | `self, screenPoint` | client | 1-50 |
| `UIMobileJoystickLogic` | `Initialize` | `self` | client | 1-3 |
| `UIMobileJoystickLogic` | `isMobileNpcTapBlockedByUI` | `self, screenPoint` | client | 1-23 |
| `UIMobileJoystickLogic` | `isScreenPointBlockedByMobileHudPanel` | `self, screenPoint, path` | client | 1-9 |
| `UIMobileJoystickLogic` | `isScreenPointBlockedByWindowUI` | `self, screenPoint` | client | 1-34 |
| `UIMobileJoystickLogic` | `isScreenPointInsideMobileJoystick` | `self, screenPoint` | client | 1-23 |
| `UIMobileJoystickLogic` | `isScreenPointInsideUIEntity` | `self, screenPoint, entity` | client | 1-31 |
| `UIMobileJoystickLogic` | `OnEndPlay` | `self` | client | 1-11 |
| `UIMobileJoystickLogic` | `onMobileNpcScreenTouch` | `self, event` | client | 1-29 |
| `UIMobileJoystickLogic` | `onMobileNpcScreenTouchRelease` | `self, event` | client | 1-47 |
| `UIMobileJoystickLogic` | `prepareMobileJoystickClient` | `self` | client | 1-3 |
| `UIMobileJoystickLogic` | `raiseMobileJoystickBlockedUI` | `self` | client | 1-13 |
| `UIMobileJoystickLogic` | `setMobileJoystickVisible` | `self, visible` | client | 1-22 |
| `UINotice` | `createNotice` | `self, type, message, msgAlignment, msgOutline, addMsgPad, contentType, defInputStr, withComboBox, canComboBoxTextEdit, listBoxItems, disableCancelBtn, withSound, callbackOKBtn, forceMSWPosY` | client | 1-223 |
| `UINotice` | `executeCallbackAndDestroyUI` | `self, cancel` | client | 1-59 |
| `UINotice` | `getNoticeInputText` | `self, inputText` | client | 1-11 |
| `UINotice` | `insertUICallback` | `self, entity, callback, callbackCanel` | client | 1-6 |
| `UINotice` | `insertUINotice` | `self, uiNotice` | client | 1-3 |
| `UINotice` | `removeLastUINotice` | `self` | client | 1-10 |
| `UINotice` | `removeUINotice` | `self, entity` | client | 1-10 |
| `UINotice` | `showAlertUI` | `self, message` | client | 1-3 |
| `UINotice` | `showAuctionBuyConfirmYesNoUI` | `self, message, callback, forceMSWPosY` | client | 1-4 |
| `UINotice` | `showBtAutoUI` | `self, message, callback` | client | 1-3 |
| `UINotice` | `showComboBoxUI` | `self, message, listBoxItems, canComboBoxTextEdit, callback, forceMSWPosY` | client | 1-3 |
| `UINotice` | `showComboBoxUIDefault` | `self, message, listBoxItems, canComboBoxTextEdit, defaultMsg, callback, forceMSWPosY` | client | 1-3 |
| `UINotice` | `showDropItemUI` | `self, message, default, callback` | client | 1-3 |
| `UINotice` | `showInputAndComboBoxUI` | `self, message, listBoxItems, canComboBoxTextEdit, callback, forceMSWPosY` | client | 1-3 |
| `UINotice` | `showInputIntegerUI` | `self, message, defInput, callback, forceMSWPosY` | client | 1-4 |
| `UINotice` | `showInputUI` | `self, message, defInputStr, callback, forceMSWPosY` | client | 1-3 |
| `UINotice` | `showInputUILimit` | `self, message, defInputStr, characterLimit, callback, forceMSWPosY` | client | 1-15 |
| `UINotice` | `showMobileInputIntegerUI` | `self, message, defInput, callback, forceMSWPosY` | client | 1-9 |
| `UINotice` | `showYesNoUI` | `self, message, callback, forceMSWPosY` | client | 1-3 |
| `UINotice` | `spawnNotice` | `self, type, disableCancelBtn` | client | 1-22 |
| `UIUtilLogic` | `getCursorUIPosition` | `self` | client | 1-29 |
| `UIUtilLogic` | `getCursorWorldPosition` | `self` | client | 1-5 |
| `UIUtilLogic` | `getWorldViewBounds` | `self` | client | 1-11 |
| `UIUtilLogic` | `isAAResoultion` | `self` | client | 1-6 |
| `UIUtilLogic` | `screenDeltaToUI` | `self, screenDelta` | client | 1-25 |
| `UIUtilLogic` | `screenPointToUI` | `self, screenPoint` | client | 1-22 |
| `UIWindowLogic` | `applyWindowMagnet` | `self, movingEntity, uiDelta` | client | 1-271 |
| `UIWindowLogic` | `beginWindowDrag` | `self, entity` | client | 1-13 |
| `UIWindowLogic` | `clearData` | `self` | client | 1-13 |
| `UIWindowLogic` | `clearHoverdUI` | `self` | client | 1-5 |
| `UIWindowLogic` | `closeAranSkillGuideIfOpen` | `self` | client | 1-16 |
| `UIWindowLogic` | `closeMobileUIByPriority` | `self` | client | 1-27 |
| `UIWindowLogic` | `closeTopUIByMobileQuickButton` | `self` | client | 1-29 |
| `UIWindowLogic` | `createFloatNotice` | `self, type, text, duration, disableRichText` | client | 1-11 |
| `UIWindowLogic` | `createUI` | `self, key, model, enable` | client | 1-24 |
| `UIWindowLogic` | `destroyUI` | `self, key` | client | 1-10 |
| `UIWindowLogic` | `enableUI` | `self, e` | client | 1-69 |
| `UIWindowLogic` | `endWindowDrag` | `self, entity` | client | 1-6 |
| `UIWindowLogic` | `ensureOpenedUICountAtLeastVisibleWindows` | `self` | client | 1-12 |
| `UIWindowLogic` | `equalsHoverdUI` | `self, entity` | client | 1-3 |
| `UIWindowLogic` | `getUI` | `self, key` | client | 1-3 |
| `UIWindowLogic` | `getUIScreenRect` | `self` | client | 1-19 |
| `UIWindowLogic` | `getWindowMagnetOffsetX` | `self, entity` | client | 1-12 |
| `UIWindowLogic` | `getWindowMagnetPosition` | `self, entity, pos` | client | 1-10 |
| `UIWindowLogic` | `getWindowRect` | `self, entity, posOverride` | client | 1-32 |
| `UIWindowLogic` | `getWindowRoot` | `self, entity` | client | 1-18 |
| `UIWindowLogic` | `HandleKeyDownEvent` | `self, event` | client | 1-72 |
| `UIWindowLogic` | `isCursorBlockedByAnyWindow` | `self` | client | 1-10 |
| `UIWindowLogic` | `isCursorBlockedByHigherWindow` | `self, entity` | client | 1-28 |
| `UIWindowLogic` | `isCursorInsideWindow` | `self, entity` | client | 1-31 |
| `UIWindowLogic` | `isOpenUI` | `self` | client | 1-6 |
| `UIWindowLogic` | `moveToTopLayer` | `self, entity` | client | 1-40 |
| `UIWindowLogic` | `recoverWindowPositionOnOpen` | `self, entity` | client | 1-58 |
| `UIWindowLogic` | `setHoverdUI` | `self, entity` | client | 1-5 |
| `UIWindowLogic` | `setOpenedUICount` | `self, delta` | client | 1-3 |
| `UIWindowLogic` | `setUI` | `self, key, ui` | client | 1-3 |
| `UIWindowLogic` | `shouldRecoverWindowPositionOnOpen` | `self, entity` | client | 1-14 |
| `UIWindowLogic` | `showMakerUI` | `self` | client | 1-11 |
| `UIWindowLogic` | `showRaiseUI` | `self, itemID` | client | 1-5 |
| `UIWindowLogic` | `showWheelUI` | `self, value` | client | 1-5 |
| `UIWindowLogic` | `suppressEscapeOnce` | `self` | client | 1-3 |
| `ULID` | `EncodeRandom` | `self, length` | client | 1-14 |
| `ULID` | `EncodeTime` | `self, time, length` | client | 1-18 |
| `ULID` | `make` | `self` | client | 1-6 |
| `ULID` | `OnBeginPlay` | `self` | client | 1-25 |
| `UpdateManager` | `insertUpdateCallback` | `self, callback, delayFrames` | client | 1-7 |
| `UpdateManager` | `insertUpdateEnable` | `self, entity` | client | 1-4 |
| `UpdateManager` | `insertUpdateInputText` | `self, entity, text` | client | 1-4 |
| `UpdateManager` | `insertUpdateVisible` | `self, entity, visible` | client | 1-4 |
| `UpdateManager` | `OnUpdate` | `self, delta` | client | 1-67 |
| `UpdateManager` | `removeUpdateEnable` | `self, entity` | client | 1-10 |
| `UseItemManager` | `addTeleportMap` | `self, senderUserId` | server-only | 1-39 |
| `UseItemManager` | `applyConsumeItemBuff` | `self, user, itemID, duration` | server-only | 1-150 |
| `UseItemManager` | `applyTeleportScrollPosition` | `self` | client | 1-16 |
| `UseItemManager` | `canOpenTeleportUIInCurrentMap` | `self` | client | 1-16 |
| `UseItemManager` | `canUseTeleportItemByLevelClient` | `self` | client | 1-11 |
| `UseItemManager` | `canUseTeleportItemByLevelServer` | `self, user, userId` | server-only | 1-10 |
| `UseItemManager` | `clearMiracleCubeSessionIdClient` | `self` | client | 1-3 |
| `UseItemManager` | `clearMiracleCubeUIStateClient` | `self` | client | 1-11 |
| `UseItemManager` | `clearTeleportInputFieldClient` | `self` | client | 1-15 |
| `UseItemManager` | `clearTeleportSelectionClient` | `self` | client | 1-7 |
| `UseItemManager` | `closeMiracleCubeUI` | `self` | client | 1-9 |
| `UseItemManager` | `closeTeleportUI` | `self` | client | 1-17 |
| `UseItemManager` | `closeTryMacroUI` | `self` | client | 1-16 |
| `UseItemManager` | `completeInventorySlotExpand` | `self, user, selected` | server-only | 1-71 |
| `UseItemManager` | `confirmTeleportCharacterMove` | `self, targetName, mapName, mapId` | client | 1-17 |
| `UseItemManager` | `consumeTeleportItemServer` | `self, user, userId` | server-only | 1-16 |
| `UseItemManager` | `detectMacroAllowIdleInDedicatedMap` | `self, user` | server-only | 1-6 |
| `UseItemManager` | `detectMacroApplyInvincible` | `self, target, invincibleUntil` | server-only | 1-6 |
| `UseItemManager` | `detectMacroCancelAll` | `self, reason` | server-only | 1-18 |
| `UseItemManager` | `detectMacroCancelByUserId` | `self, targetuserid, reason` | server-only | 1-27 |
| `UseItemManager` | `detectMacroCloseClient` | `self` | client | 1-15 |
| `UseItemManager` | `detectMacroCreateExternalCid` | `self` | server-only | 1-7 |
| `UseItemManager` | `detectMacroEnsureServerState` | `self` | server-only | 1-5 |
| `UseItemManager` | `detectMacroFinalizeByEventUserId` | `self, eventUserId, reason` | server-only | 1-18 |
| `UseItemManager` | `detectMacroFinalizeByUserId` | `self, targetuserid, success, reason` | server-only | 1-63 |
| `UseItemManager` | `detectMacroForceFailByLogout` | `self, senderUserId` | server-only | 1-12 |
| `UseItemManager` | `detectMacroGetBlockReason` | `self, user, automatic` | server-only | 1-29 |
| `UseItemManager` | `detectMacroGetReceiveCooldownRemain` | `self, targetuserid` | server-only | 1-19 |
| `UseItemManager` | `detectMacroGetUrlQueryParam` | `self, url, key` | server-only | 1-24 |
| `UseItemManager` | `detectMacroHasActiveStateByUserId` | `self, userId` | server-only | 1-7 |
| `UseItemManager` | `detectMacroHasLiveMob` | `self, user` | server-only | 1-7 |
| `UseItemManager` | `detectMacroHeartbeat` | `self, senderUserId` | server-only | 1-13 |
| `UseItemManager` | `detectMacroInitUI` | `self` | client | 1-28 |
| `UseItemManager` | `detectMacroIsExcludedMap` | `self, user` | server-only | 1-34 |
| `UseItemManager` | `detectMacroIsHunting` | `self, user` | server-only | 1-10 |
| `UseItemManager` | `detectMacroIsMapTransitioning` | `self, user` | server-only | 1-23 |
| `UseItemManager` | `detectMacroMarkHunting` | `self, user` | server-only | 1-9 |
| `UseItemManager` | `detectMacroOpenClient` | `self, url, externalCid` | client | 1-36 |
| `UseItemManager` | `detectMacroPollUrl` | `self` | client | 1-29 |
| `UseItemManager` | `detectMacroRandomInteger` | `self, minValue, maxValue` | server-only | 1-6 |
| `UseItemManager` | `detectMacroReleaseInvincible` | `self, target` | server-only | 1-8 |
| `UseItemManager` | `detectMacroReleaseInvincibleClient` | `self` | client | 1-7 |
| `UseItemManager` | `detectMacroReportResult` | `self, success, pageUrl, senderUserId` | server-only | 1-27 |
| `UseItemManager` | `detectMacroRescheduleAllAutoChecks` | `self, minSec, maxSec` | server-only | 1-7 |
| `UseItemManager` | `detectMacroRestoreClient` | `self, retryCount` | client | 1-41 |
| `UseItemManager` | `detectMacroScheduleNextAutoCheck` | `self, user, minSec, maxSec` | server-only | 1-6 |
| `UseItemManager` | `detectMacroShowFailNotice` | `self, reason` | client | 1-18 |
| `UseItemManager` | `detectMacroShowSuccessNotice` | `self` | client | 1-3 |
| `UseItemManager` | `detectMacroStart` | `self, requester, target` | server-only | 1-3 |
| `UseItemManager` | `detectMacroStartAuto` | `self, target` | server-only | 1-3 |
| `UseItemManager` | `detectMacroStartForced` | `self, requester, target` | server-only | 1-3 |
| `UseItemManager` | `detectMacroStartInternal` | `self, requester, target, automatic, ignoreReceiveCooldown` | server-only | 1-73 |
| `UseItemManager` | `detectMacroStartWatch` | `self` | client | 1-6 |
| `UseItemManager` | `detectMacroStopWatch` | `self` | client | 1-6 |
| `UseItemManager` | `detectMacroVerifySuccess` | `self, state, pageUrl` | server-only | 1-14 |
| `UseItemManager` | `effectConsumeItem` | `self, user, itemID` | server-only | 1-127 |
| `UseItemManager` | `findMobInItemRange` | `self, user, targetMobId, left, right, top, bottom` | server-only | 1-39 |
| `UseItemManager` | `findTeleportInputFieldClient` | `self, root` | client | 1-21 |
| `UseItemManager` | `getColorLensTargetFace` | `self, currentFace, itemId` | client | 1-13 |
| `UseItemManager` | `getDeathPenaltySkipReasonForConsumeItem` | `self, user, itemId` | server-only | 1-7 |
| `UseItemManager` | `getMiracleCubeItemIdClient` | `self` | client | 1-7 |
| `UseItemManager` | `getMiracleCubeItemNameClient` | `self` | client | 1-7 |
| `UseItemManager` | `getMiracleCubeRerollCostByReqLevel` | `self, reqLevel, senderUserId` | server-only | 1-12 |
| `UseItemManager` | `getMiracleCubeSessionIdClient` | `self` | client | 1-10 |
| `UseItemManager` | `getPendingInventorySlotExpandIncrease` | `self, user` | server-only | 1-20 |
| `UseItemManager` | `getTeleportInputNameClient` | `self` | client | 1-16 |
| `UseItemManager` | `getTeleportMapDisplayName` | `self, mapId` | client | 1-7 |
| `UseItemManager` | `getTeleportVisibleRowCount` | `self` | client | 1-4 |
| `UseItemManager` | `getTryMacroTargetName` | `self` | client | 1-14 |
| `UseItemManager` | `HandleTeleportMouseMoveEvent` | `self, event` | client | 1-37 |
| `UseItemManager` | `HandleTeleportMouseScrollEvent` | `self, event` | client | 1-35 |
| `UseItemManager` | `hasCreatedEquipInInventoryOrTamingSlot` | `self, user, createdItemId` | server-only | 1-18 |
| `UseItemManager` | `hasStrongerConsumeItemBuffClient` | `self, user, item` | client | 1-30 |
| `UseItemManager` | `hasTeleportItemServer` | `self, user` | server-only | 1-7 |
| `UseItemManager` | `isDojoPotionExhaustedClient` | `self, user, itemId` | client | 1-4 |
| `UseItemManager` | `isDojoPotionItem` | `self, itemId` | client | 1-4 |
| `UseItemManager` | `isDojoPotionLimitedMap` | `self, user` | client | 1-8 |
| `UseItemManager` | `isHPPotion` | `self, itemID` | client | 1-20 |
| `UseItemManager` | `isMegaphoneCashItem` | `self, itemId` | client | 1-9 |
| `UseItemManager` | `isMiracleCubeUIOpenServer` | `self, userId` | server-only | 1-10 |
| `UseItemManager` | `isMPPotion` | `self, itemID` | client | 1-20 |
| `UseItemManager` | `isPetPotionOverheal` | `self, user, petPotionType` | server-only | 1-30 |
| `UseItemManager` | `isPotentialChangeBlockedRewardEquip` | `self, itemId` | client | 1-4 |
| `UseItemManager` | `isTeleportBlockedMap` | `self, mapId` | server-only | 1-34 |
| `UseItemManager` | `OnBeginPlay` | `self` | client | 1-18 |
| `UseItemManager` | `onClickTeleportMove` | `self` | client | 1-28 |
| `UseItemManager` | `onClickTeleportRemove` | `self` | client | 1-17 |
| `UseItemManager` | `onClickTryMacroYes` | `self` | client | 1-9 |
| `UseItemManager` | `OnMapEnter` | `self` | client | 1-10 |
| `UseItemManager` | `onMiracleCubeKeyDown` | `self, event` | client | 1-7 |
| `UseItemManager` | `onMiracleCubeRerollServer` | `self, slot, mesoCost, consumeCube, equipULID, cubeSessionId, cubeItemId, senderUserId` | server-only | 1-132 |
| `UseItemManager` | `onMiracleCubeUICleanupClient` | `self, cube` | client | 1-15 |
| `UseItemManager` | `onPetLifeWaterDisplayInfoClient` | `self, pets` | client | 1-7 |
| `UseItemManager` | `onTeleportKeyDown` | `self, event` | client | 1-7 |
| `UseItemManager` | `onTeleportSelectRow` | `self, index` | client | 1-9 |
| `UseItemManager` | `onTryMacroKeyDown` | `self, event` | client | 1-10 |
| `UseItemManager` | `onUseCashItemServer` | `self, itemId, data, senderUserId` | server-only | 1-341 |
| `UseItemManager` | `onUseItemClient` | `self, invType, slotId, byPet, petPotionType` | client | 1-312 |
| `UseItemManager` | `onUseItemServer` | `self, itemId, data, senderUserId` | server-only | 1-829 |
| `UseItemManager` | `onUsePetLifeWaterResultClient` | `self, resultCode` | client | 1-15 |
| `UseItemManager` | `openTeleportUI` | `self` | client | 1-31 |
| `UseItemManager` | `openTryMacroUI` | `self` | client | 1-33 |
| `UseItemManager` | `playSkillBookResultEffect` | `self, user, userId, bookName, success, canTry` | server-only | 1-18 |
| `UseItemManager` | `removeTeleportMap` | `self, selectedIndex, senderUserId` | server-only | 1-21 |
| `UseItemManager` | `removeUsedItem` | `self, user, itemId, consumeInvType, consumeSlot` | server-only | 1-32 |
| `UseItemManager` | `requestClickedRaise` | `self, questID, consumeItemID, senderUserId` | server-only | 1-82 |
| `UseItemManager` | `requestPetLifeWaterDisplayInfoServer` | `self, senderUserId` | server-only | 1-52 |
| `UseItemManager` | `requestRaise` | `self, questID, senderUserId` | server-only | 1-30 |
| `UseItemManager` | `requestTeleportCharacterMove` | `self, targetName, senderUserId` | server-only | 1-55 |
| `UseItemManager` | `requestTeleportMapList` | `self, senderUserId` | server-only | 1-8 |
| `UseItemManager` | `requestTryMacro` | `self, targetName, senderUserId` | server-only | 1-78 |
| `UseItemManager` | `responseRaise` | `self, questID, qrData` | client | 1-9 |
| `UseItemManager` | `setMiracleCubeUIOpenServer` | `self, isOpen, senderUserId` | server-only | 1-21 |
| `UseItemManager` | `setTeleportRowSelectedVisual` | `self, row, selected` | client | 1-17 |
| `UseItemManager` | `setTeleportTextColor` | `self, target, color` | client | 1-9 |
| `UseItemManager` | `spawnKarmaScissors` | `self` | client | 1-9 |
| `UseItemManager` | `spawnMiracleCubeUI` | `self, cubeItemId` | client | 1-76 |
| `UseItemManager` | `spawnPetLifeWater` | `self, useSlot` | client | 1-19 |
| `UseItemManager` | `startInventorySlotExpandScript` | `self, user, itemId, cashUseSlot` | server-only | 1-23 |
| `UseItemManager` | `syncTeleportMapList` | `self, mapList` | client | 1-20 |
| `UseItemManager` | `teleportChangeScroll` | `self, direction` | client | 1-18 |
| `UseItemManager` | `teleportInitUI` | `self` | client | 1-124 |
| `UseItemManager` | `teleportMoveToCharacter` | `self, targetName, senderUserId` | server-only | 1-51 |
| `UseItemManager` | `teleportMoveToMap` | `self, mapId, senderUserId` | server-only | 1-8 |
| `UseItemManager` | `teleportMoveToMapInternal` | `self, user, mapId, userId` | server-only | 1-42 |
| `UseItemManager` | `teleportMoveToRegisteredMap` | `self, mapIndex, senderUserId` | server-only | 1-19 |
| `UseItemManager` | `toggleTeleportUI` | `self` | client | 1-14 |
| `UseItemManager` | `truncateTeleportMapNameClient` | `self, mapName` | client | 1-22 |
| `UseItemManager` | `tryMacroInitUI` | `self` | client | 1-31 |
| `UseItemManager` | `tryUseItemClient` | `self, itemId, petPotionType` | client | 1-15 |
| `UseItemManager` | `updateTeleportScrollUI` | `self` | client | 1-45 |
| `UseItemManager` | `updateTeleportUIList` | `self` | client | 1-43 |
| `UseItemManager` | `useMaplePointExchangeCouponServer` | `self, user, userId, itemId, cashUseSlot` | server-only | 1-39 |
| `UseItemManager` | `usePetLifeWaterServer` | `self, user, userId, itemId, data, cashUseSlot` | server-only | 1-70 |
| `UserListUILogic` | `bindBlacklistActionButtons` | `self` | client | 1-47 |
| `UserListUILogic` | `bindBlacklistActionButtonsOnBeginPlay` | `self` | client | 1-15 |
| `UserListUILogic` | `bindBlacklistScrollEvents` | `self` | client | 1-48 |
| `UserListUILogic` | `bindBlacklistSlotEvents` | `self` | client | 1-17 |
| `UserListUILogic` | `bindUserListTabTargets` | `self` | client | 1-16 |
| `UserListUILogic` | `changeTab` | `self, toTabName` | client | 1-36 |
| `UserListUILogic` | `changeTabByTabButton` | `self` | client | 1-24 |
| `UserListUILogic` | `collectBlacklistSlots` | `self` | client | 1-18 |
| `UserListUILogic` | `ensureBlacklistActionButtonsEnabled` | `self` | client | 1-20 |
| `UserListUILogic` | `ensureBlacklistSlotCapacity` | `self, targetCount` | client | 1-25 |
| `UserListUILogic` | `findBlacklistScrollRoot` | `self, root` | client | 1-27 |
| `UserListUILogic` | `getBlacklistNowText` | `self` | client | 1-5 |
| `UserListUILogic` | `getChildByPath` | `self, root, childPath` | client | 1-17 |
| `UserListUILogic` | `getNormalizedBlackList` | `self` | client | 1-36 |
| `UserListUILogic` | `hideBlacklistEmptyText` | `self` | client | 1-32 |
| `UserListUILogic` | `isBlacklistTabActive` | `self` | client | 1-3 |
| `UserListUILogic` | `isCursorInBlacklistArea` | `self` | client | 1-12 |
| `UserListUILogic` | `isCursorInBlacklistTouchArea` | `self` | client | 1-10 |
| `UserListUILogic` | `normalizeTabName` | `self, tabName` | client | 1-6 |
| `UserListUILogic` | `OnBeginPlay` | `self` | client | 1-85 |
| `UserListUILogic` | `onBlacklistMouseMove` | `self, event` | client | 1-23 |
| `UserListUILogic` | `onBlacklistMouseScroll` | `self, event` | client | 1-31 |
| `UserListUILogic` | `onClickBlacklistBtAdd` | `self` | client | 1-58 |
| `UserListUILogic` | `onClickBlacklistBtRemove` | `self` | client | 1-20 |
| `UserListUILogic` | `onClickBlacklistScrollNext` | `self` | client | 1-9 |
| `UserListUILogic` | `onClickBlacklistScrollPrev` | `self` | client | 1-9 |
| `UserListUILogic` | `onClickBlacklistSlot` | `self, slotIndex` | client | 1-13 |
| `UserListUILogic` | `OnEndPlay` | `self` | client | 1-12 |
| `UserListUILogic` | `renderBlackList` | `self` | client | 1-17 |
| `UserListUILogic` | `renderBlacklistRows` | `self, list` | client | 1-44 |
| `UserListUILogic` | `renderGuild` | `self` | client | 1-10 |
| `UserListUILogic` | `resolveBlacklistViewRefs` | `self` | client | 1-26 |
| `UserListUILogic` | `setBlacklistSlotSelectVisual` | `self, slot, selected` | client | 1-17 |
| `UserListUILogic` | `setBlacklistSlotText` | `self, target, value` | client | 1-22 |
| `UserListUILogic` | `setBlacklistTextColor` | `self, target, color` | client | 1-12 |
| `UserListUILogic` | `setLocalPlayerBlackList` | `self, list` | client | 1-24 |
| `UserListUILogic` | `showUI` | `self, tabName` | client | 1-31 |
| `UserListUILogic` | `sortBlacklistSlotsByName` | `self` | client | 1-13 |
| `UserListUILogic` | `updateBlacklistMembersText` | `self, members, capacity` | client | 1-18 |
| `UserListUILogic` | `updateBlacklistScrollMetric` | `self` | client | 1-13 |
| `UserListUILogic` | `updateBlacklistScrollUI` | `self, listCount` | client | 1-35 |
| `VecUtils` | `AccSpeed` | `self, v, f, m, vMax, tSec` | client | 1-15 |
| `VecUtils` | `DecSpeed` | `self, v, f, m, vMax, tSec` | client | 1-14 |
| `Victoria` | `_2010winter_coldStone` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `_2010winter_magma` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `Afirentalk` | `self, player, udc` | server-only | 1-25 |
| `Victoria` | `aMatchMove` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `amoria_enter` | `self, player, udc` | server-only | 1-16 |
| `Victoria` | `baby_cow` | `self, player, udc` | server-only | 1-29 |
| `Victoria` | `bookPrize` | `self, player, udc` | server-only | 1-55 |
| `Victoria` | `bush1` | `self, player, udc` | server-only | 1-20 |
| `Victoria` | `bush2` | `self, player, udc` | server-only | 1-25 |
| `Victoria` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `Victoria` | `createVariedFlowerTubeEquip` | `self, itemId, expTime` | server-only | 1-14 |
| `Victoria` | `curseforest` | `self, player, udc` | server-only | 1-22 |
| `Victoria` | `Depart_topFloorIn` | `self, player, udc` | server-only | 1-49 |
| `Victoria` | `dojang_move` | `self, player, udc` | server-only | 1-19 |
| `Victoria` | `DollMaster` | `self, player, udc` | server-only | 1-33 |
| `Victoria` | `Donation` | `self, player, udc` | server-only | 1-123 |
| `Victoria` | `elizaHarp1` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp2` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp3` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp4` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp5` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp6` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `elizaHarp7` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `evanFarmCT` | `self, player, udc` | server-only | 1-11 |
| `Victoria` | `Event00` | `self, player, udc` | server-only | 1-90 |
| `Victoria` | `Event03_1` | `self, player, udc` | server-only | 1-30 |
| `Victoria` | `Event04` | `self, player, udc` | server-only | 1-35 |
| `Victoria` | `Event05` | `self, player, udc` | server-only | 1-161 |
| `Victoria` | `Event07` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `firework` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `florina1` | `self, player, udc` | server-only | 1-12 |
| `Victoria` | `florina2` | `self, player, udc` | server-only | 1-61 |
| `Victoria` | `flower_in` | `self, player, udc` | server-only | 1-45 |
| `Victoria` | `flower_out` | `self, player, udc` | server-only | 1-10 |
| `Victoria` | `flower_tube_exchange` | `self, player, udc` | server-only | 1-64 |
| `Victoria` | `friend00` | `self, player, udc` | server-only | 1-49 |
| `Victoria` | `friend01` | `self, player, udc` | server-only | 1-32 |
| `Victoria` | `getFlowerTubeExchangeItems` | `self` | server-only | 1-20 |
| `Victoria` | `getFlowerTubeExpireTime` | `self` | server-only | 1-5 |
| `Victoria` | `getRank` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `giveupMoonPicture` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `go_secretroom` | `self, player, udc` | server-only | 1-10 |
| `Victoria` | `goDungeon` | `self, player, udc` | server-only | 1-16 |
| `Victoria` | `goldrich` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `handleElizaHarp` | `self, player, soundPath` | server-only | 1-31 |
| `Victoria` | `herb_in` | `self, player, udc` | server-only | 1-60 |
| `Victoria` | `herb_out` | `self, player, udc` | server-only | 1-8 |
| `Victoria` | `hotel1` | `self, player, udc` | server-only | 1-50 |
| `Victoria` | `jane` | `self, player, udc` | server-only | 1-88 |
| `Victoria` | `kasandra` | `self, player, udc` | server-only | 1-27 |
| `Victoria` | `leaderAl` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `legend_hair` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `levelContents` | `self, player, udc` | server-only | 1-3 |
| `Victoria` | `make_ston` | `self, player, udc` | server-only | 1-123 |
| `Victoria` | `Manji` | `self, player, udc` | server-only | 1-32 |
| `Victoria` | `mapleTCG` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `mc_move` | `self, player, udc` | server-only | 1-458 |
| `Victoria` | `medal_rank` | `self, player, udc` | server-only | 1-76 |
| `Victoria` | `metroIm` | `self, player, udc` | server-only | 1-189 |
| `Victoria` | `mike` | `self, player, udc` | server-only | 1-16 |
| `Victoria` | `minigame00` | `self, player, udc` | server-only | 1-88 |
| `Victoria` | `mom_cow` | `self, player, udc` | server-only | 1-58 |
| `Victoria` | `nautil_Abel1` | `self, player, udc` | server-only | 1-21 |
| `Victoria` | `nautil_black` | `self, player, udc` | server-only | 1-22 |
| `Victoria` | `nautil_cow` | `self, player, udc` | server-only | 1-28 |
| `Victoria` | `nautil_letter` | `self, player, udc` | server-only | 1-18 |
| `Victoria` | `nautil_stone` | `self, player, udc` | server-only | 1-8 |
| `Victoria` | `npc_1011101` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `npc_1057001` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `party_6_spra` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `pc_weapon` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `pet_letter` | `self, player, udc` | server-only | 1-21 |
| `Victoria` | `pet_life` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `pet_lifeitem` | `self, player, udc` | server-only | 1-115 |
| `Victoria` | `petmaster` | `self, player, udc` | server-only | 1-4 |
| `Victoria` | `pigmy` | `self, player, udc` | server-only | 1-124 |
| `Victoria` | `pigmy_guide` | `self, player, udc` | server-only | 1-29 |
| `Victoria` | `rithTeleport` | `self, player, udc` | server-only | 1-127 |
| `Victoria` | `sca_Shade` | `self, player, udc` | server-only | 1-7 |
| `Victoria` | `subway_get1` | `self, player, udc` | server-only | 1-20 |
| `Victoria` | `subway_get2` | `self, player, udc` | server-only | 1-20 |
| `Victoria` | `subway_get3` | `self, player, udc` | server-only | 1-19 |
| `Victoria` | `subway_in` | `self, player, udc` | server-only | 1-61 |
| `Victoria` | `subway_in2` | `self, player, udc` | server-only | 1-5 |
| `Victoria` | `subway_out` | `self, player, udc` | server-only | 1-8 |
| `Victoria` | `subway_ticket` | `self, player, udc` | server-only | 1-63 |
| `Victoria` | `viola_blue` | `self, player, udc` | server-only | 1-21 |
| `Victoria` | `viola_pink` | `self, player, udc` | server-only | 1-20 |
| `Victoria` | `viola_white` | `self, player, udc` | server-only | 1-20 |
| `Victoria` | `world_trip` | `self, player, udc` | server-only | 1-56 |
| `WeaponAttackMotion` | `getAllAttackMotions` | `self` | client | 1-35 |
| `WeaponAttackMotion` | `getFinalAttackMotion` | `self, weaponType` | client | 1-9 |
| `WeaponAttackMotion` | `initializeAttackMotions` | `self` | client | 1-76 |
| `WeaponAttackMotion` | `OnBeginPlay` | `self` | client | 1-4 |
| `WeaponAttackType` | `getWeaponAttackType` | `self, weaponType` | client | 1-15 |
| `WeaponAttackType` | `getWeaponAttackTypeName` | `self, attackType` | client | 1-12 |
| `WeaponType` | `getAttackSoundByWeaponType` | `self, type, shoot` | client | 1-48 |
| `WeaponType` | `getWeaponNameByType` | `self, type` | client | 1-41 |
| `WeaponType` | `getWeaponTypeByItemID` | `self, weaponID` | client | 1-3 |
| `WebDBStorageService` | `backupLegacyEntries` | `self, entries` | server-only | 1-24 |
| `WebDBStorageService` | `buildLoadedValueMap` | `self, entries, queue` | server-only | 1-41 |
| `WebDBStorageService` | `buildSavedKeys` | `self, entries` | server-only | 1-7 |
| `WebDBStorageService` | `CreateCharacter` | `self, userId, nickname, maxPlayer, playerInfo, equipmentData` | server-only | 1-37 |
| `WebDBStorageService` | `DeleteCharacter` | `self, userId, playerId` | server-only | 1-45 |
| `WebDBStorageService` | `DeleteNickname` | `self, nickname, playerId` | server-only | 1-40 |
| `WebDBStorageService` | `GetCreatorDataStorage` | `self` | server-only | 1-3 |
| `WebDBStorageService` | `HasNicknameAndWait` | `self, nickname` | server-only | 1-37 |
| `WebDBStorageService` | `LoadAsyncWait` | `self, entries` | server-only | 1-46 |
| `WebDBStorageService` | `LoadCharacterList` | `self, userId` | server-only | 1-34 |
| `WebDBStorageService` | `requestPending` | `self, action, playerId, payload, callback` | server-only | 1-23 |
| `WebDBStorageService` | `requestPendingSync` | `self, action, playerId, payload` | server-only | 1-28 |
| `WebDBStorageService` | `resolveEntrySenderId` | `self, entries` | server-only | 1-17 |
| `WebDBStorageService` | `resolveKeyInfo` | `self, key` | server-only | 1-27 |
| `WebDBStorageService` | `sanitizeJsonString` | `self, raw` | server-only | 1-21 |
| `WebDBStorageService` | `sanitizeValue` | `self, value` | server-only | 1-27 |
| `WebDBStorageService` | `Save` | `self, entries` | server-only | 1-27 |
| `WebDBStorageService` | `SaveAsyncWait` | `self, entries` | server-only | 1-49 |
| `WorldConstants` | `applyLiveInstanceFlags` | `self, liveInstanceIds` | server-only | 1-39 |
| `WorldConstants` | `buildChannelRowsForUI` | `self` | server-only | 1-178 |
| `WorldConstants` | `buildChannelRowsVersion` | `self, rows` | server-only | 1-34 |
| `WorldConstants` | `canTransferToWorldInstanceId` | `self, worldInstanceId` | server-only | 1-7 |
| `WorldConstants` | `createPlanetChannelSenderTag` | `self` | server-only | 1-9 |
| `WorldConstants` | `enableBtEmergency` | `self` | client | 1-5 |
| `WorldConstants` | `finishRefreshLiveInstanceFlags` | `self, liveInstanceIds` | server-only | 1-5 |
| `WorldConstants` | `flushInstanceListCallbacks` | `self, result, response` | server-only | 1-17 |
| `WorldConstants` | `getChannelRowsForUI` | `self` | server-only | 1-22 |
| `WorldConstants` | `getCurrentWorldInstanceIndex` | `self` | server-only | 1-11 |
| `WorldConstants` | `getInstanceStatusLogging` | `self` | server-only | 1-19 |
| `WorldConstants` | `getWorldInstanceIndexById` | `self, worldInstanceId` | server-only | 1-7 |
| `WorldConstants` | `getWorldInstanceInfoEntryById` | `self, worldInstanceId` | server-only | 1-55 |
| `WorldConstants` | `getWorldName` | `self` | server-only | 1-3 |
| `WorldConstants` | `getWorldNameWithChannel` | `self` | server-only | 1-7 |
| `WorldConstants` | `getWorldNameWithChannelByID` | `self, id` | server-only | 1-7 |
| `WorldConstants` | `HandleWorldEmergencyEvent` | `self, event` | client | 1-3 |
| `WorldConstants` | `isCashShopAuctionBlockedCurrentMap` | `self, user` | client | 1-7 |
| `WorldConstants` | `isCashShopAuctionBlockedMap` | `self, mapId` | client | 1-3 |
| `WorldConstants` | `isTokyoKrAccount` | `self, userId` | server-only | 1-14 |
| `WorldConstants` | `loadCurrentInstanceMaxUserCount` | `self` | server-only | 1-36 |
| `WorldConstants` | `mayDayMyWorld` | `self, enable` | server-only | 1-27 |
| `WorldConstants` | `OnBeginPlay` | `self` | client | 1-87 |
| `WorldConstants` | `onBtEmergency` | `self` | client | 1-9 |
| `WorldConstants` | `OnEndPlay` | `self` | server-only | 1-4 |
| `WorldConstants` | `OnSyncProperty` | `self, name, value` | client | 1-8 |
| `WorldConstants` | `onTimer` | `self` | server-only | 1-6 |
| `WorldConstants` | `refreshLiveInstanceFlags` | `self` | server-only | 1-28 |
| `WorldConstants` | `refreshLiveInstanceFlagsAsync` | `self, callback` | server-only | 1-79 |
| `WorldConstants` | `requestInstanceList` | `self, callback, senderPlayerId, senderName` | server-only | 1-44 |
| `WorldConstants` | `requestWorldEmergency` | `self, senderUserId` | server-only | 1-36 |
| `WorldConstants` | `startInstanceStatusLogging` | `self` | server-only | 1-14 |
| `WorldConstants` | `updateInstanceList` | `self, response` | server-only | 1-92 |
| `WorldLogService` | `appendAuctionRequestKey` | `self, entry, row` | server-only | 1-27 |
| `WorldLogService` | `appendMesoAfter` | `self, contents, player` | server-only | 1-10 |
| `WorldLogService` | `buildAuctionLogContents` | `self, row` | server-only | 1-38 |
| `WorldLogService` | `buildAuctionTargetUser` | `self, row` | server-only | 1-11 |
| `WorldLogService` | `buildBossPartyMembers` | `self, users` | server-only | 1-24 |
| `WorldLogService` | `buildDeliveryItems` | `self, items` | server-only | 1-55 |
| `WorldLogService` | `buildDeliveryTargetUser` | `self, accountId, nickname` | server-only | 1-9 |
| `WorldLogService` | `buildLogItemGainItems` | `self, items, omitDefaultEquipOptions, includeNegativeItems` | server-only | 1-65 |
| `WorldLogService` | `buildMakerGemEntries` | `self, gems` | server-only | 1-18 |
| `WorldLogService` | `buildMakerItemEntry` | `self, itemId, itemCount, equipInfo` | server-only | 1-24 |
| `WorldLogService` | `buildMakerRecipeEntries` | `self, recipeList` | server-only | 1-22 |
| `WorldLogService` | `buildPotentialReadableLogTarget` | `self, equipInfo` | server-only | 1-25 |
| `WorldLogService` | `buildTradeItems` | `self, tradeItems` | server-only | 1-45 |
| `WorldLogService` | `buildTradeOptions` | `self, equipInfo` | server-only | 1-43 |
| `WorldLogService` | `buildTradeParticipants` | `self, player1, player2` | server-only | 1-17 |
| `WorldLogService` | `buildUser` | `self, player` | server-only | 1-25 |
| `WorldLogService` | `enqueue` | `self, payload` | server-only | 1-3 |
| `WorldLogService` | `flush` | `self` | server-only | 1-124 |
| `WorldLogService` | `getDefaultEquipLogFlag` | `self, equipData` | server-only | 1-30 |
| `WorldLogService` | `getEquipReqLevelForLog` | `self, equipInfo` | server-only | 1-27 |
| `WorldLogService` | `getLogEquipULID` | `self, equipInfo` | server-only | 1-12 |
| `WorldLogService` | `getPlayerMesoAfter` | `self, player` | server-only | 1-7 |
| `WorldLogService` | `isAdminPlayer` | `self, player` | server-only | 1-7 |
| `WorldLogService` | `isDefaultEquipLogOptions` | `self, equipInfo` | server-only | 1-45 |
| `WorldLogService` | `logAuctionBuy` | `self, player, row` | server-only | 1-16 |
| `WorldLogService` | `logAuctionBuyerReward` | `self, player, row` | server-only | 1-15 |
| `WorldLogService` | `logAuctionCancel` | `self, player, row` | server-only | 1-15 |
| `WorldLogService` | `logAuctionLocker` | `self, player, item, action2` | server-only | 1-38 |
| `WorldLogService` | `logAuctionRegister` | `self, player, row` | server-only | 1-15 |
| `WorldLogService` | `logAuctionRegisterUi` | `self, player, action2, itemStack, quantity, price, invType, invSlot` | server-only | 1-37 |
| `WorldLogService` | `logAuctionReturn` | `self, player, row` | server-only | 1-15 |
| `WorldLogService` | `logAuctionSellerReward` | `self, player, row, rewardMeso` | server-only | 1-19 |
| `WorldLogService` | `logBoss` | `self, player, action, bossId, partyMembers` | server-only | 1-15 |
| `WorldLogService` | `logCashShopCharge` | `self, player, action2_str, itemId, itemName, chargePoint, remainingPoint, totalPoint` | server-only | 1-22 |
| `WorldLogService` | `logCashShopCoupon` | `self, player, couponId, couponKey, requestKey, deliveryId` | server-only | 1-20 |
| `WorldLogService` | `logCashShopLocker` | `self, player, item, action2` | server-only | 1-43 |
| `WorldLogService` | `logCashShopPurchase` | `self, player, items, usedPoint, remainingPoint, action2` | server-only | 1-38 |
| `WorldLogService` | `logCashShopRebate` | `self, player, item, refundPoint, remainingPoint` | server-only | 1-26 |
| `WorldLogService` | `logCashShopRefund` | `self, player, item` | server-only | 1-30 |
| `WorldLogService` | `logChangeChannel` | `self, player, id` | server-only | 1-10 |
| `WorldLogService` | `logChangeMap` | `self, player, prevmap` | server-only | 1-10 |
| `WorldLogService` | `logChangeMapFail` | `self, player, nextmap, portal` | server-only | 1-11 |
| `WorldLogService` | `logChangeNickName` | `self, accountid, playerid, nickname, changednickname` | server-only | 1-7 |
| `WorldLogService` | `logCharacterCreate` | `self, accountid, playerid, nickname` | server-only | 1-7 |
| `WorldLogService` | `logCharacterDelete` | `self, accountid, playerid, nickname` | server-only | 1-7 |
| `WorldLogService` | `logChat` | `self, player, type, chat` | server-only | 1-8 |
| `WorldLogService` | `logChatWhisper` | `self, player, receivername, chat` | server-only | 1-8 |
| `WorldLogService` | `logDeliveryCancel` | `self, player, targetid, targetname, items, meso, deliveryid` | server-only | 1-13 |
| `WorldLogService` | `logDeliveryDelete` | `self, player, targetid, targetname, items, meso, deliveryid, reason` | server-only | 1-13 |
| `WorldLogService` | `logDeliveryReceive` | `self, player, senderid, sendername, items, meso, deliveryid` | server-only | 1-14 |
| `WorldLogService` | `logDeliverySend` | `self, player, receiverid, receivername, items, meso, deliveryid` | server-only | 1-14 |
| `WorldLogService` | `logDeliverySendFail` | `self, player, receiverid, receivername, items, meso, deliveryid, reason` | server-only | 1-18 |
| `WorldLogService` | `logDeliverySendSlot` | `self, player, action2, slotid, itemid, itemcount, equipInfo, itemSN, remain` | server-only | 1-43 |
| `WorldLogService` | `logDojang` | `self, player, action_, contents_` | server-only | 1-8 |
| `WorldLogService` | `logDonationKing` | `self, player, seasonId, mapId, amount, total, requestKey, challengeVersion` | server-only | 1-20 |
| `WorldLogService` | `logDonationKingReview` | `self, playerId, playerName, seasonId, mapId, amount, requestKey, challengeVersion, deductionState, beforeMeso, afterMeso, requestStatus, responseCode, deliveryStatus, reviewReason` | server-only | 1-37 |
| `WorldLogService` | `logEquipmentChange` | `self, player, action2, itemId, beforeEquip, afterEquip` | server-only | 1-15 |
| `WorldLogService` | `logExternalDataAccess` | `self, player, action, contents` | server-only | 1-12 |
| `WorldLogService` | `logGuildAction` | `self, player, action2, guildId, guildName, targetPlayerId, targetName, details` | server-only | 1-14 |
| `WorldLogService` | `logHack` | `self, player, hackid, text` | server-only | 1-10 |
| `WorldLogService` | `logItemBook` | `self, player, bookItemid, action` | server-only | 1-8 |
| `WorldLogService` | `logItemDrop` | `self, player, items, meso, action2, sourceType, sourceId` | server-only | 1-37 |
| `WorldLogService` | `logItemFlow` | `self, player, logTitle, flowType, itemId, quantity, starttime, source, sourceID, itemSN, remain, equipInfo, saleId` | server-only | 1-3 |
| `WorldLogService` | `logItemFlowBatchWithContext` | `self, player, logTitle, flowType, items, starttime, source, sourceID, saleId, worldAction2, worldSource` | server-only | 1-88 |
| `WorldLogService` | `logItemFlowWithContext` | `self, player, logTitle, flowType, itemId, quantity, starttime, source, sourceID, itemSN, remain, equipInfo, saleId, worldAction2, worldSource` | server-only | 1-3 |
| `WorldLogService` | `logItemGain` | `self, player, items, sourceType, sourceId, meso, sourcePlayerId, sourcePlayerName` | server-only | 1-57 |
| `WorldLogService` | `logItemMiracleCube` | `self, player, beforeEquip, afterEquip, cubeItemId, mesoCost, cubeSessionId, cubeItemSN` | server-only | 1-30 |
| `WorldLogService` | `logItemProtect` | `self, player, action2, itemId, beforeEquip, afterEquip, mesoCost` | server-only | 1-21 |
| `WorldLogService` | `logItemScroll` | `self, player, action, beforeItem, afterItem, scrollItemId` | server-only | 1-12 |
| `WorldLogService` | `logItemUse` | `self, player, useItemid, action` | server-only | 1-8 |
| `WorldLogService` | `logLevelup` | `self, player` | server-only | 1-10 |
| `WorldLogService` | `logLogin` | `self, player` | server-only | 1-7 |
| `WorldLogService` | `logLogout` | `self, player` | server-only | 1-7 |
| `WorldLogService` | `logLogoutTry` | `self, player` | server-only | 1-7 |
| `WorldLogService` | `logMacro` | `self, player, action2` | server-only | 1-10 |
| `WorldLogService` | `logMacroByUser` | `self, user, action2` | server-only | 1-10 |
| `WorldLogService` | `logMaker` | `self, player, action2, contents` | server-only | 1-12 |
| `WorldLogService` | `logMakerCraft` | `self, player, action2, sourceItem, recipeItems, mesoCost, mountCatalyst, catalystItemId, gemItems, resultItems` | server-only | 1-22 |
| `WorldLogService` | `logMakerCrystal` | `self, player, sourceItemId, sourceItemCount, resultItemId` | server-only | 1-14 |
| `WorldLogService` | `logMakerDisassemble` | `self, player, sourceItemId, sourceEquipInfo, rewardItems, mesoCost` | server-only | 1-7 |
| `WorldLogService` | `logMesoPickupAgg` | `self, player, pickupCount, mesoAmount, startTime` | server-only | 1-18 |
| `WorldLogService` | `logMobKill` | `self, player, mobID, isBoss, ownerType, partyID, partyMembers` | server-only | 1-13 |
| `WorldLogService` | `logMobKillPlayerAgg` | `self, player, killCount, startTime` | server-only | 1-16 |
| `WorldLogService` | `logRunScript` | `self, player, scriptName, resolvedName, npcId, itemNpcId` | server-only | 1-17 |
| `WorldLogService` | `logSkillAttackUse` | `self, player, skillId, skillLevel` | server-only | 1-18 |
| `WorldLogService` | `logStorageInput` | `self, player, invType, itemId, itemCount, equipInfo` | server-only | 1-23 |
| `WorldLogService` | `logStorageMesoInput` | `self, player, amount` | server-only | 1-12 |
| `WorldLogService` | `logStorageMesoOutput` | `self, player, amount` | server-only | 1-12 |
| `WorldLogService` | `logStorageOutput` | `self, player, invType, itemId, itemCount, equipInfo` | server-only | 1-23 |
| `WorldLogService` | `logTrade` | `self, player, targetplayer, participants, tradeSessionId` | server-only | 1-21 |
| `WorldLogService` | `logTradeRequest` | `self, player, targetplayer, action, tradeSessionId` | server-only | 1-12 |
| `WorldLogService` | `logUpdateQuestEx` | `self, player, npcid, qid, qkey, qvalue` | server-only | 1-8 |
| `WorldLogService` | `logUpdateQuestState` | `self, player, npcid, qid, state` | server-only | 1-8 |
| `WorldLogService` | `logUserReport` | `self, player, targetname, reason, description, cost` | server-only | 1-14 |
| `WorldLogService` | `normalizeCompactEquipLogInfo` | `self, equipInfo` | server-only | 1-47 |
| `WorldLogService` | `normalizeItemSourceType` | `self, sourceType` | server-only | 1-11 |
| `WorldLogService` | `normalizeTransactionLogItemCount` | `self, itemId, itemCount` | server-only | 1-6 |
| `WorldLogService` | `nowIso8601` | `self` | server-only | 1-18 |
| `WorldLogService` | `OnBeginPlay` | `self` | server-only | 1-3 |
| `WorldLogService` | `OnEndPlay` | `self` | server-only | 1-4 |
| `WorldLogService` | `parseAuctionPayloadFromRow` | `self, row` | server-only | 1-19 |
| `WorldLogService` | `resolveItemFlowAction2` | `self, logTitle, flowType, source` | server-only | 1-22 |
| `WorldLogService` | `shouldLogTransactionItem` | `self, itemId, itemCount` | server-only | 1-9 |
| `WorldLogService` | `stripCompactEquipLogAliases` | `self, logInfo` | server-only | 1-15 |
| `WorldLogService` | `utcDateTimeTextToKST` | `self, utcText` | server-only | 1-22 |
| `WorldMapManager` | `activateSearchInputField` | `self` | client | 1-15 |
| `WorldMapManager` | `appendMobDropItems` | `self, lines, mobId, prefix` | client | 1-8 |
| `WorldMapManager` | `appendMonsterLines` | `self, lines, mobList, mapId` | client | 1-25 |
| `WorldMapManager` | `buildNameList` | `self, ids, type` | client | 1-27 |
| `WorldMapManager` | `buildSearchLines` | `self, mapId` | client | 1-37 |
| `WorldMapManager` | `buildSearchLinesByQuery` | `self, query, mapId` | client | 1-128 |
| `WorldMapManager` | `changeSearchScroll` | `self, movingDirection` | client | 1-8 |
| `WorldMapManager` | `closeWorldMap` | `self` | client | 1-18 |
| `WorldMapManager` | `collectReviveMobIds` | `self, mobId, bucket, visited` | client | 1-31 |
| `WorldMapManager` | `ensureRewardCache` | `self` | client | 1-30 |
| `WorldMapManager` | `ensureSearchIndex` | `self` | client | 1-50 |
| `WorldMapManager` | `ensureSearchInputUI` | `self` | client | 1-176 |
| `WorldMapManager` | `ensureSearchListUI` | `self` | client | 1-166 |
| `WorldMapManager` | `ensureWorldMapSearchData` | `self` | client | 1-65 |
| `WorldMapManager` | `getItemNameCached` | `self, itemId` | client | 1-12 |
| `WorldMapManager` | `getMapLifeIds` | `self, mapId` | client | 1-50 |
| `WorldMapManager` | `getMobDisplayText` | `self, mobId` | client | 1-10 |
| `WorldMapManager` | `getMobNameCached` | `self, mobId` | client | 1-12 |
| `WorldMapManager` | `getRewardItemNames` | `self, mobId` | client | 1-25 |
| `WorldMapManager` | `getSearchInputText` | `self` | client | 1-27 |
| `WorldMapManager` | `hasRewardDataInReviveChain` | `self, mobId, visited` | client | 1-32 |
| `WorldMapManager` | `hidePath` | `self` | client | 1-8 |
| `WorldMapManager` | `hideSearchItem` | `self, entry` | client | 1-7 |
| `WorldMapManager` | `OnBeginPlay` | `self` | client | 1-51 |
| `WorldMapManager` | `onEscapeKeyDown` | `self, event` | client | 1-12 |
| `WorldMapManager` | `onMouseRightClick` | `self, event` | client | 1-10 |
| `WorldMapManager` | `onSearchButtonClick` | `self` | client | 1-4 |
| `WorldMapManager` | `onSearchInputSubmit` | `self, event` | client | 1-4 |
| `WorldMapManager` | `onSearchMouseMove` | `self, event` | client | 1-26 |
| `WorldMapManager` | `onSearchMouseScroll` | `self, event` | client | 1-22 |
| `WorldMapManager` | `performWorldMapSearch` | `self, query` | client | 1-60 |
| `WorldMapManager` | `scheduleSearchRerender` | `self` | client | 1-12 |
| `WorldMapManager` | `setSearchItem` | `self, entry, line` | client | 1-367 |
| `WorldMapManager` | `setSearchLoading` | `self, show` | client | 1-39 |
| `WorldMapManager` | `setSelectedSearchEntry` | `self, mapId, entryType, entryId` | client | 1-6 |
| `WorldMapManager` | `showMapMonsterList` | `self, mapId` | client | 1-60 |
| `WorldMapManager` | `showPath` | `self, RUID, pos` | client | 1-14 |
| `WorldMapManager` | `showWorldMap` | `self, imgName` | client | 1-191 |
| `WorldMapManager` | `toggleMonsterExpand` | `self, mobId` | client | 1-20 |
| `WorldMapManager` | `updateSearchScrollUI` | `self` | client | 1-33 |
| `WorldPlayerActivityService` | `adminItemRemoveUlid` | `self, equipInfo` | server-only | 1-6 |
| `WorldPlayerActivityService` | `applyEnterControlToClient` | `self, canEnterDailyGift, canEnterMaker, canEnterDelivery, canEnterGuild` | client | 1-38 |
| `WorldPlayerActivityService` | `closeWebLogoutBlockingUIClient` | `self, user` | client | 1-23 |
| `WorldPlayerActivityService` | `enqueue` | `self, type, msg, senderPlayerId, senderName, receiverPlayerId, receiverName, msg2` | server-only | 1-16 |
| `WorldPlayerActivityService` | `findAdminTargetUser` | `self, playerId, accountId` | server-only | 1-19 |
| `WorldPlayerActivityService` | `flush` | `self` | server-only | 1-6 |
| `WorldPlayerActivityService` | `getFriendReceivers` | `self, users, friendName` | server-only | 1-28 |
| `WorldPlayerActivityService` | `getMegaphoneChannelTag` | `self, channel` | server-only | 1-12 |
| `WorldPlayerActivityService` | `handleDeliveryArrived` | `self, t` | server-only | 1-47 |
| `WorldPlayerActivityService` | `handleEffectConsumeItem` | `self, t, u` | server-only | 1-30 |
| `WorldPlayerActivityService` | `handleFriendChat` | `self, t, u` | server-only | 1-29 |
| `WorldPlayerActivityService` | `handleFriendRequest` | `self, t` | server-only | 1-46 |
| `WorldPlayerActivityService` | `handleGuildChat` | `self, t, u` | server-only | 1-41 |
| `WorldPlayerActivityService` | `handleInviteFriend` | `self, t` | server-only | 1-37 |
| `WorldPlayerActivityService` | `handleInviteParty` | `self, t` | server-only | 1-55 |
| `WorldPlayerActivityService` | `handleMegaphone` | `self, t, u` | server-only | 1-104 |
| `WorldPlayerActivityService` | `handlePartyJobUpdate` | `self, t, p` | server-only | 1-22 |
| `WorldPlayerActivityService` | `handlePartyLevelUpdate` | `self, t, p` | server-only | 1-22 |
| `WorldPlayerActivityService` | `handlePartyRequest` | `self, t, p` | server-only | 1-24 |
| `WorldPlayerActivityService` | `handlePlayerLogin` | `self, t, u` | server-only | 1-9 |
| `WorldPlayerActivityService` | `handlePlayerLogout` | `self, t, u` | server-only | 1-8 |
| `WorldPlayerActivityService` | `handleResponse` | `self, response` | server-only | 1-176 |
| `WorldPlayerActivityService` | `handleScrollNotice` | `self, t, u` | server-only | 1-7 |
| `WorldPlayerActivityService` | `handleToMessage` | `self, t` | server-only | 1-37 |
| `WorldPlayerActivityService` | `handleWebAdminAccountInfoUpdate` | `self, t` | server-only | 1-28 |
| `WorldPlayerActivityService` | `handleWebAdminItemInfoUpdate` | `self, t` | server-only | 1-49 |
| `WorldPlayerActivityService` | `handleWebAdminItemRemove` | `self, t` | server-only | 1-65 |
| `WorldPlayerActivityService` | `handleWebBanScripts` | `self, t` | server-only | 1-14 |
| `WorldPlayerActivityService` | `handleWebChatBan` | `self, t` | server-only | 1-12 |
| `WorldPlayerActivityService` | `handleWebDeliveryArrived` | `self, t` | server-only | 1-3 |
| `WorldPlayerActivityService` | `handleWebEnterControl` | `self, t` | server-only | 1-76 |
| `WorldPlayerActivityService` | `handleWebJailUser` | `self, t` | server-only | 1-27 |
| `WorldPlayerActivityService` | `handleWebKick` | `self, t` | server-only | 1-9 |
| `WorldPlayerActivityService` | `handleWebLogoutAll` | `self, t` | server-only | 1-14 |
| `WorldPlayerActivityService` | `handleWebMacroAdminUpdate` | `self, t` | server-only | 1-51 |
| `WorldPlayerActivityService` | `handleWebMacroQuestion` | `self, t` | server-only | 1-27 |
| `WorldPlayerActivityService` | `handleWebMoveInstance` | `self, t, u` | server-only | 1-34 |
| `WorldPlayerActivityService` | `handleWebMoveMap` | `self, t` | server-only | 1-17 |
| `WorldPlayerActivityService` | `handleWebNotice` | `self, t, u` | server-only | 1-48 |
| `WorldPlayerActivityService` | `handleWebReloadPlayerLocker` | `self, t` | server-only | 1-58 |
| `WorldPlayerActivityService` | `handleWebReloadShopReward` | `self, t` | server-only | 1-6 |
| `WorldPlayerActivityService` | `handleWebServerRate` | `self, t` | server-only | 1-21 |
| `WorldPlayerActivityService` | `isBlackListBlocked` | `self, receiverUser, senderName` | server-only | 1-12 |
| `WorldPlayerActivityService` | `isMegaphoneChatLogBlocked` | `self, receiverUser` | server-only | 1-9 |
| `WorldPlayerActivityService` | `nextActivityDedupeKey` | `self, type, senderPlayerId` | server-only | 1-4 |
| `WorldPlayerActivityService` | `OnBeginPlay` | `self` | server-only | 1-5 |
| `WorldPlayerActivityService` | `OnEndPlay` | `self` | server-only | 1-3 |
| `WorldPlayerActivityService` | `prepareReturnToTitleFromWebClient` | `self, user` | client | 1-17 |
| `WorldPlayerActivityService` | `removeAdminEquipmentItemBySlotUlid` | `self, user, slot, subSlot, ulid` | server-only | 1-19 |
| `WorldPlayerActivityService` | `removeAdminInventoryItemBySlotUlid` | `self, user, invType, slotIndex, ulid` | server-only | 1-20 |
| `WorldPlayerActivityService` | `removeAdminStorageItemBySlotUlid` | `self, accountId, invType, slotIndex, ulid` | server-only | 1-25 |
| `WorldPlayerActivityService` | `requestReturnToTitleFromWeb` | `self` | client | 1-16 |
| `WorldPlayerActivityService` | `restoreUnifiedQueue` | `self, batchMsgs` | server-only | 1-8 |
| `WorldPlayerActivityService` | `returnToTitleFromWebClient` | `self` | client | 1-18 |
| `WorldPlayerActivityService` | `takeUnifiedPayload` | `self` | server-only | 1-43 |
| `WorldPlayerActivityService` | `worldBroadcastEffectConsumeItem` | `self, fieldID, itemID` | server-only | 1-13 |
| `WorldRequestService` | `buildActivityBatchSummary` | `self, messages` | server-only | 1-40 |
| `WorldRequestService` | `buildRequestBatchSummary` | `self, messages` | server-only | 1-46 |
| `WorldRequestService` | `buildResponseQueueSummary` | `self, queue` | server-only | 1-23 |
| `WorldRequestService` | `enqueue` | `self, type, msg, senderPlayerId, senderName, receiverPlayerId, receiverName, callback` | server-only | 1-59 |
| `WorldRequestService` | `flush` | `self` | server-only | 1-245 |
| `WorldRequestService` | `getRequestTypeName` | `self, requestType` | server-only | 1-108 |
| `WorldRequestService` | `handleResponse` | `self, response` | server-only | 1-49 |
| `WorldRequestService` | `isProfileRequestTypeFilterEmpty` | `self` | server-only | 1-3 |
| `WorldRequestService` | `isProfileRequestTypeMatched` | `self, requestType` | server-only | 1-16 |
| `WorldRequestService` | `nextRequestDedupeKey` | `self, type, senderPlayerId` | server-only | 1-4 |
| `WorldRequestService` | `OnBeginPlay` | `self` | server-only | 1-137 |
| `WorldRequestService` | `OnEndPlay` | `self` | server-only | 1-4 |
| `WorldRequestService` | `resetFlushTimerIntervalForTest` | `self, intervalSeconds` | server-only | 1-12 |
| `WorldRequestService` | `restoreRequestMessagesByType` | `self, requestBatchMsgs, requestType` | server-only | 1-16 |
| `WorldRequestService` | `sanitizeForLog` | `self, text` | server-only | 1-10 |
| `WorldRequestService` | `setLoggedinPlayer` | `self, playerId, loggedin` | server-only | 1-4 |
| `WorldRequestService` | `setProfileRequestTypeFilter` | `self, filterText` | server-only | 1-5 |
| `WorldRequestService` | `shouldProfileRequestBatch` | `self, messages` | server-only | 1-18 |
| `WorldRequestService` | `trimForLog` | `self, text, maxLen` | server-only | 1-14 |
| `WorldRequestService` | `updateAccount` | `self, user, onlynugu` | server-only | 1-50 |
| `WorldRequestService` | `updatePlayer` | `self, user` | server-only | 1-61 |
| `WzUtils` | `getBoolean` | `self, data, default` | client | 1-14 |
| `WzUtils` | `getDouble` | `self, data, default` | client | 1-7 |
| `WzUtils` | `getFastVector` | `self, data, default` | client | 1-8 |
| `WzUtils` | `getImageRUID` | `self, data, default` | client | 1-9 |
| `WzUtils` | `getInteger` | `self, data, default` | client | 1-7 |
| `WzUtils` | `getSize` | `self, data, default` | client | 1-8 |
| `WzUtils` | `getString` | `self, data, default` | client | 1-11 |
| `WzUtils` | `getVector` | `self, data, default` | client | 1-8 |
| `WzUtils` | `getWzTbl` | `self, node, path` | client | 1-26 |
| `WzUtils` | `intToARGB` | `self, v` | client | 1-9 |
| `WzUtils` | `parseAnimation` | `self, dir` | client | 1-3 |
| `WzUtils` | `parseAnimation_` | `self, dir, parseIndex` | client | 1-202 |
| `WzUtils` | `ParseGenericWzCollectionWZ` | `self, collectionName, key` | client | 1-22 |
| `WzUtils` | `parseWzData` | `self, data` | client | 1-16 |
| `WzUtils` | `unwrapValue` | `self, data` | client | 1-6 |
| `WzUtils` | `updateUnionBox` | `self, unionBox, center, size` | client | 1-37 |
| `ZLayer` | `clear` | `self` | client | 1-4 |
| `ZLayer` | `getFront` | `self` | client | 1-7 |
| `ZLayer` | `getRear` | `self` | client | 1-7 |
| `Zakum` | `cacheScriptFunc` | `self` | server-only | 1-35 |
| `Zakum` | `getZakumSlotStatusText` | `self, enterStarted, bossStarted` | server-only | 1-11 |
| `Zakum` | `showZakumSlotUnavailableMessage` | `self, slot, enterStarted, bossStarted, udc` | server-only | 1-20 |
| `Zakum` | `Zakum00` | `self, player, udc` | server-only | 1-231 |
| `Zakum` | `Zakum01` | `self, player, udc` | server-only | 1-102 |
| `Zakum` | `Zakum02` | `self, player, udc` | server-only | 1-23 |
| `Zakum` | `Zakum03` | `self, player, udc` | server-only | 1-38 |
| `Zakum` | `Zakum04` | `self, player, udc` | server-only | 1-7 |
| `Zakum` | `Zakum05` | `self, player, udc` | server-only | 1-138 |
| `Zakum` | `Zakum06` | `self, player, udc` | server-only | 1-22 |
| `Zakum1` | `cacheScriptFunc` | `self` | server-only | 1-39 |
| `Zakum1` | `getActiveZakumSlot` | `self, isNormal` | server-only | 1-19 |
| `Zakum1` | `getAvailableZakumSlot` | `self, isNormal` | server-only | 1-27 |
| `Zakum1` | `getCurrentZakumEnterFieldSet` | `self, isNormal` | server-only | 1-13 |
| `Zakum1` | `getCurrentZakumEnterFieldSetByMapId` | `self, mapId` | server-only | 1-9 |
| `Zakum1` | `getCurrentZakumSlot` | `self, isNormal` | server-only | 1-8 |
| `Zakum1` | `getCurrentZakumSlotByMapId` | `self, mapId` | server-only | 1-9 |
| `Zakum1` | `getStrReg` | `self, mapId, reg` | server-only | 1-4 |
| `Zakum1` | `getZakumBossFieldSet` | `self, slot` | server-only | 1-11 |
| `Zakum1` | `getZakumBossMapId` | `self, slot` | server-only | 1-11 |
| `Zakum1` | `getZakumEnterFieldSet` | `self, slot` | server-only | 1-11 |
| `Zakum1` | `getZakumMasterSlotByName` | `self, name` | server-only | 1-23 |
| `Zakum1` | `getZakumRegField` | `self, mapId` | server-only | 1-3 |
| `Zakum1` | `getZakumSlotByMapId` | `self, mapId` | server-only | 1-13 |
| `Zakum1` | `isZakumSlotAvailable` | `self, slot` | server-only | 1-8 |
| `Zakum1` | `setStrReg` | `self, mapId, reg, value` | server-only | 1-4 |
| `Zakum1` | `showZakumSlotBusyMessage` | `self, slot, udc` | server-only | 1-9 |
| `Zakum1` | `zakum_accept` | `self, p, udc` | server-only | 1-243 |
| `Zakum1` | `zakum_ban` | `self, p, udc` | server-only | 1-49 |
| `Zakum1` | `zakum_ban2` | `self, p, name, udc` | server-only | 1-56 |
| `Zakum1` | `zakum_bancheck` | `self, mapId, cName` | server-only | 1-9 |
| `Zakum1` | `zakum_banned` | `self, mapId, cName, udc` | server-only | 1-11 |
| `Zakum1` | `zakum_check` | `self, mapId, cName` | server-only | 1-9 |
| `Zakum1` | `zakum_clearReg` | `self, mapId` | server-only | 1-58 |
| `Zakum1` | `zakum_entercheck2` | `self, mapId, udc` | server-only | 1-9 |
| `Zakum1` | `zakum_enterMsg` | `self, mapId` | server-only | 1-8 |
| `Zakum1` | `zakum_getname` | `self, mapId, udc` | server-only | 1-14 |
| `Zakum1` | `zakum_in` | `self, mapId, cName, udc` | server-only | 1-40 |
| `Zakum1` | `zakum_master` | `self, p, udc` | server-only | 1-10 |
| `Zakum1` | `zakum_master_timecheck` | `self, p, udc, isNormal` | server-only | 1-23 |
| `Zakum1` | `zakum_master_timecheck1` | `self, p, isNormal` | server-only | 1-20 |
| `Zakum1` | `zakum_noban` | `self, p, udc` | server-only | 1-46 |
| `Zakum1` | `zakum_out` | `self, mapId, cName, udc` | server-only | 1-99 |
| `Zakum1` | `zakum_partycheck` | `self, p, udc, isNormal` | server-only | 1-15 |
| `Zakum1` | `zakum_reset` | `self, mapId` | server-only | 1-10 |
| `Zakum1` | `zakum_resetPassed` | `self, cTime, lTime, isNormal` | server-only | 1-11 |
| `Zakum1` | `zakum_timecheck1` | `self, p, isNormal` | server-only | 1-24 |
| `Zakum1` | `zakum_timecheck2` | `self, p, udc, isNormal` | server-only | 1-26 |
| `ZtlSecureUtils` | `new_integer` | `self, val` | client | 1-15 |
| `ZtlSecureUtils` | `rol` | `self, x, r` | client | 1-5 |
| `ZtlSecureUtils` | `ror` | `self, x, r` | client | 1-5 |
| `ZtlSecureUtils` | `s32` | `self, x` | client | 1-7 |
| `ZtlSecureUtils` | `u32` | `self, x` | client | 1-3 |
| `_RUIDManager` | `get` | `self, path` | client | 1-3 |
| `_RUIDManager` | `getByCollection` | `self, collection, path` | client | 1-7 |
| `_RUIDManager` | `getKeyByValue` | `self, value` | client | 1-20 |
| `_RUIDManager` | `loadRUID` | `self` | client | 1-19 |
| `_RUIDManager` | `loadRUIDData` | `self, collection` | client | 1-22 |
| `aran00` | `aran_helper` | `self, player, udc` | server-only | 1-22 |
| `aran00` | `aranDirection` | `self, player, udc` | server-only | 1-24 |
| `aran00` | `aranTutorAlone` | `self, player, udc` | server-only | 1-4 |
| `aran00` | `aranTutorAloneX` | `self, player, udc` | server-only | 1-6 |
| `aran00` | `aranTutorArrow0` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorArrow1` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorArrow2` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorArrow3` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorGuide0` | `self, player, udc` | server-only | 1-8 |
| `aran00` | `aranTutorGuide1` | `self, player, udc` | server-only | 1-8 |
| `aran00` | `aranTutorGuide2` | `self, player, udc` | server-only | 1-8 |
| `aran00` | `aranTutorLost` | `self, player, udc` | server-only | 1-8 |
| `aran00` | `aranTutorMono0` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorMono1` | `self, player, udc` | server-only | 1-8 |
| `aran00` | `aranTutorMono2` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorMono3` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `aranTutorOut1` | `self, player, udc` | server-only | 1-14 |
| `aran00` | `aranTutorOut2` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `aranTutorOut3` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `awake` | `self, player, udc` | server-only | 1-24 |
| `aran00` | `cacheScriptFunc` | `self` | server-only | 1-41 |
| `aran00` | `enterRienFirst` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `iceCave` | `self, player, udc` | server-only | 1-15 |
| `aran00` | `outChild` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `q21000s` | `self, player, udc` | server-only | 1-15 |
| `aran00` | `q21001e` | `self, player, udc` | server-only | 1-34 |
| `aran00` | `q21001s` | `self, player, udc` | server-only | 1-23 |
| `aran00` | `q21010e` | `self, player, udc` | server-only | 1-16 |
| `aran00` | `q21010s` | `self, player, udc` | server-only | 1-19 |
| `aran00` | `q21011e` | `self, player, udc` | server-only | 1-21 |
| `aran00` | `q21012e` | `self, player, udc` | server-only | 1-16 |
| `aran00` | `q21012s` | `self, player, udc` | server-only | 1-13 |
| `aran00` | `q21013e` | `self, player, udc` | server-only | 1-15 |
| `aran00` | `q21013s` | `self, player, udc` | server-only | 1-11 |
| `aran00` | `q21015s` | `self, player, udc` | server-only | 1-12 |
| `aran00` | `q21016s` | `self, player, udc` | server-only | 1-10 |
| `aran00` | `q21017s` | `self, player, udc` | server-only | 1-16 |
| `aran00` | `q21018s` | `self, player, udc` | server-only | 1-10 |
| `aran00` | `q21100s` | `self, player, udc` | server-only | 1-17 |
| `aran00` | `q21101s` | `self, player, udc` | server-only | 1-19 |
| `aran00` | `rien` | `self, player, udc` | server-only | 1-4 |
| `aran00` | `rienArrow` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `rienTutor1` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `rienTutor2` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `rienTutor3` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `rienTutor4` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `rienTutor5` | `self, player, udc` | server-only | 1-5 |
| `aran00` | `rienTutor6` | `self, player, udc` | server-only | 1-7 |
| `aran00` | `rienTutor7` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `rienTutor8` | `self, player, udc` | server-only | 1-9 |
| `aran00` | `talkHelena` | `self, player, udc` | server-only | 1-19 |
| `aran01` | `cacheScriptFunc` | `self` | server-only | 1-41 |
| `aran01` | `enterGym` | `self, player, udc` | server-only | 1-15 |
| `aran01` | `enterMCave` | `self, player, udc` | server-only | 1-34 |
| `aran01` | `mirrorCave` | `self, player, udc` | server-only | 1-7 |
| `aran01` | `moveBefore` | `self, player, udc` | server-only | 1-5 |
| `aran01` | `moveNext` | `self, player, udc` | server-only | 1-9 |
| `aran01` | `q21200e` | `self, player, udc` | server-only | 1-24 |
| `aran01` | `q21200s` | `self, player, udc` | server-only | 1-7 |
| `aran01` | `q21201e` | `self, player, udc` | server-only | 1-27 |
| `aran01` | `q21202e` | `self, player, udc` | server-only | 1-17 |
| `aran01` | `q21202s` | `self, player, udc` | server-only | 1-11 |
| `aran01` | `q21700s` | `self, player, udc` | server-only | 1-18 |
| `aran01` | `q21703e` | `self, player, udc` | server-only | 1-15 |
| `aran01` | `q21703s` | `self, player, udc` | server-only | 1-15 |
| `aran01` | `q21704s` | `self, player, udc` | server-only | 1-10 |
| `aran01` | `q21712s` | `self, player, udc` | server-only | 1-9 |
| `aran01` | `q21716s` | `self, player, udc` | server-only | 1-10 |
| `aran01` | `q21719s` | `self, player, udc` | server-only | 1-11 |
| `aran01` | `q21720e` | `self, player, udc` | server-only | 1-20 |
| `aran01` | `q21729s` | `self, player, udc` | server-only | 1-8 |
| `aran01` | `rienCaveEnter` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `cacheScriptFunc` | `self` | server-only | 1-41 |
| `aran02` | `Disguised` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `dollMaster02` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `DollWayKeeper1` | `self, player, udc` | server-only | 1-8 |
| `aran02` | `DollWayKeeper2` | `self, player, udc` | server-only | 1-18 |
| `aran02` | `downHelena` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `downTrue` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `enterBackStreet` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `enterDollWay` | `self, player, udc` | server-only | 1-13 |
| `aran02` | `enterNepenthes` | `self, player, udc` | server-only | 1-15 |
| `aran02` | `enterShadow` | `self, player, udc` | server-only | 1-18 |
| `aran02` | `enterWarehouse` | `self, player, udc` | server-only | 1-16 |
| `aran02` | `giantDagoth` | `self, player, udc` | server-only | 1-8 |
| `aran02` | `outSpecialSchool` | `self, player, udc` | server-only | 1-5 |
| `aran02` | `q21300s` | `self, player, udc` | server-only | 1-7 |
| `aran02` | `q21301e` | `self, player, udc` | server-only | 1-12 |
| `aran02` | `q21302e` | `self, player, udc` | server-only | 1-19 |
| `aran02` | `q21303s` | `self, player, udc` | server-only | 1-13 |
| `aran02` | `q21600s` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `q21604s` | `self, player, udc` | server-only | 1-8 |
| `aran02` | `q21733e` | `self, player, udc` | server-only | 1-17 |
| `aran02` | `q21733s` | `self, player, udc` | server-only | 1-11 |
| `aran02` | `q21734e` | `self, player, udc` | server-only | 1-7 |
| `aran02` | `q21735e` | `self, player, udc` | server-only | 1-12 |
| `aran02` | `q21735s` | `self, player, udc` | server-only | 1-16 |
| `aran02` | `q21736s` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `q21738s` | `self, player, udc` | server-only | 1-13 |
| `aran02` | `q21739e` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `q21740e` | `self, player, udc` | server-only | 1-12 |
| `aran02` | `q21740s` | `self, player, udc` | server-only | 1-11 |
| `aran02` | `q21741s` | `self, player, udc` | server-only | 1-8 |
| `aran02` | `q21742e` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `q21742s` | `self, player, udc` | server-only | 1-19 |
| `aran02` | `q21746s` | `self, player, udc` | server-only | 1-18 |
| `aran02` | `q21747e` | `self, player, udc` | server-only | 1-14 |
| `aran02` | `q21747s` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `q21748e` | `self, player, udc` | server-only | 1-14 |
| `aran02` | `q21749s` | `self, player, udc` | server-only | 1-12 |
| `aran02` | `q21750e` | `self, player, udc` | server-only | 1-15 |
| `aran02` | `q21753s` | `self, player, udc` | server-only | 1-18 |
| `aran02` | `q21754s` | `self, player, udc` | server-only | 1-17 |
| `aran02` | `q21757e` | `self, player, udc` | server-only | 1-11 |
| `aran02` | `q21766e` | `self, player, udc` | server-only | 1-16 |
| `aran02` | `q21766s` | `self, player, udc` | server-only | 1-19 |
| `aran02` | `q21767s` | `self, player, udc` | server-only | 1-10 |
| `aran02` | `sealGarden` | `self, player, udc` | server-only | 1-5 |
| `aran02` | `ShadowWarrier` | `self, player, udc` | server-only | 1-9 |
| `aran02` | `Warehouse` | `self, player, udc` | server-only | 1-10 |
| `aran03` | `cacheScriptFunc` | `self` | server-only | 1-41 |
| `aran03` | `enterRider` | `self, player, udc` | server-only | 1-9 |
| `aran03` | `enterWolf` | `self, player, udc` | server-only | 1-8 |
| `aran03` | `outMaha` | `self, player, udc` | server-only | 1-5 |
| `aran03` | `outtestWolf` | `self, player, udc` | server-only | 1-10 |
| `aran03` | `q21400s` | `self, player, udc` | server-only | 1-6 |
| `aran03` | `q21401e` | `self, player, udc` | server-only | 1-20 |
| `aran03` | `q21401s` | `self, player, udc` | server-only | 1-19 |
| `aran03` | `q21613s` | `self, player, udc` | server-only | 1-18 |
| `aran03` | `q21618e` | `self, player, udc` | server-only | 1-23 |
| `aran03` | `q21618s` | `self, player, udc` | server-only | 1-11 |
| `cygnus0` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `cygnus0` | `createCygnus` | `self, player, udc` | server-only | 1-6 |
| `cygnus0` | `cygnus_tutor` | `self, player, udc` | server-only | 1-15 |
| `cygnus0` | `cygnusJobTutorial` | `self, player, udc` | server-only | 1-7 |
| `cygnus0` | `enterDisguise0` | `self, player, udc` | server-only | 1-10 |
| `cygnus0` | `helperCygnus` | `self, player, udc` | server-only | 1-13 |
| `cygnus0` | `q20015s` | `self, player, udc` | server-only | 1-18 |
| `cygnus0` | `startEreb` | `self, player, udc` | server-only | 1-5 |
| `cygnus0` | `tutorHelper` | `self, player, udc` | server-only | 1-11 |
| `cygnus0` | `tutorMinimap` | `self, player, udc` | server-only | 1-8 |
| `cygnus0` | `tutorquest` | `self, player, udc` | server-only | 1-23 |
| `cygnus0` | `tutorWorldmap` | `self, player, udc` | server-only | 1-8 |
| `cygnus1` | `blackShadowEli1` | `self, player, udc` | server-only | 1-13 |
| `cygnus1` | `blackShadowEli2` | `self, player, udc` | server-only | 1-5 |
| `cygnus1` | `blackShadowHene1` | `self, player, udc` | server-only | 1-15 |
| `cygnus1` | `blackShadowHene2` | `self, player, udc` | server-only | 1-5 |
| `cygnus1` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `cygnus1` | `Dollcave` | `self, player, udc` | server-only | 1-37 |
| `cygnus1` | `dollMaster00` | `self, player, udc` | server-only | 1-12 |
| `cygnus1` | `dollMaster01` | `self, player, udc` | server-only | 1-11 |
| `cygnus1` | `enterDollcave` | `self, player, udc` | server-only | 1-6 |
| `cygnus1` | `enterFirstDH` | `self, player, udc` | server-only | 1-17 |
| `cygnus1` | `enterSecondDH` | `self, player, udc` | server-only | 1-12 |
| `cygnus1` | `givebubbleDoll1` | `self, player, udc` | server-only | 1-15 |
| `cygnus1` | `givebubbleDoll2` | `self, player, udc` | server-only | 1-15 |
| `cygnus1` | `givebubbleDoll3` | `self, player, udc` | server-only | 1-28 |
| `cygnus1` | `givebubbleDoll4` | `self, player, udc` | server-only | 1-15 |
| `cygnus1` | `giveSap` | `self, player, udc` | server-only | 1-30 |
| `cygnus1` | `outMagiclib` | `self, player, udc` | server-only | 1-10 |
| `cygnus1` | `outSecondDH` | `self, player, udc` | server-only | 1-7 |
| `cygnus2` | `babyfood` | `self, player, udc` | server-only | 1-44 |
| `cygnus2` | `blackWitch` | `self, player, udc` | server-only | 1-17 |
| `cygnus2` | `cacheScriptFunc` | `self` | server-only | 1-32 |
| `cygnus2` | `desguise` | `self, player, udc, jobId, npcId` | server-only | 1-17 |
| `cygnus2` | `desguiseFlame` | `self, player, udc` | server-only | 1-4 |
| `cygnus2` | `desguiseNight` | `self, player, udc` | server-only | 1-4 |
| `cygnus2` | `desguiseSoul` | `self, player, udc` | server-only | 1-4 |
| `cygnus2` | `desguiseStrike` | `self, player, udc` | server-only | 1-4 |
| `cygnus2` | `desguiseWind` | `self, player, udc` | server-only | 1-4 |
| `cygnus2` | `enterBlackEreb` | `self, player, udc` | server-only | 1-12 |
| `cygnus2` | `enterDisguise1` | `self, player, udc` | server-only | 1-31 |
| `cygnus2` | `enterDisguise2` | `self, player, udc` | server-only | 1-31 |
| `cygnus2` | `enterDisguise3` | `self, player, udc` | server-only | 1-31 |
| `cygnus2` | `enterDisguise4` | `self, player, udc` | server-only | 1-31 |
| `cygnus2` | `enterDisguise5` | `self, player, udc` | server-only | 1-31 |
| `cygnus2` | `enterfourthDH` | `self, player, udc` | server-only | 1-18 |
| `cygnus2` | `enterthirdDH` | `self, player, udc` | server-only | 1-17 |
| `cygnus2` | `enterWitch` | `self, player, udc` | server-only | 1-13 |
| `cygnus2` | `giveupRiding` | `self, player, udc` | server-only | 1-11 |
| `cygnus2` | `inNix1` | `self, player, udc` | server-only | 1-5 |
| `cygnus2` | `inNix2` | `self, player, udc` | server-only | 1-5 |
| `cygnus2` | `outDarkEreb` | `self, player, udc` | server-only | 1-11 |
| `cygnus2` | `outNix1` | `self, player, udc` | server-only | 1-5 |
| `cygnus2` | `outNix2` | `self, player, udc` | server-only | 1-5 |
| `cygnus3` | `aaa` | `self, player, udc` | server-only | 1-4 |
| `cygnus3` | `cacheScriptFunc` | `self` | server-only | 1-32 |
