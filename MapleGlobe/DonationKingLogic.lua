

function DonationKingLogic.applyCurrentChallengeRecord(self, player, playerId, currentSeasonId, currentChallengeFound, currentChallenge)

end

function DonationKingLogic.applySnapshot(self, payload)

end

function DonationKingLogic.buildRankingText(self, rankers)

end

function DonationKingLogic.ensureCurrentSeason(self)

end

function DonationKingLogic.finishSnapshotRefresh(self, success)

end

function DonationKingLogic.formatDonationMeso(self, meso)

end

function DonationKingLogic.getClaimableRewardCount(self, player, callback)

end

function DonationKingLogic.getPreviousRankers(self, mapId)

end

function DonationKingLogic.getPreviousSeasonState(self)

end

function DonationKingLogic.getSnapshotRefreshJitterSeconds(self)

end

function DonationKingLogic.getTopRankers(self, mapId, maxCount)

end

function DonationKingLogic.getTownConfig(self, mapId)

end

function DonationKingLogic.getTownConfigs(self)

end

function DonationKingLogic.giveUpChallenge(self, player, callback)

end

function DonationKingLogic.handleStartChallengeResponse(self, playerId, seasonId, requestedMapId, callback, result, response)

end

function DonationKingLogic.invokeSnapshotCallbacks(self, callbacks, success)

end

function DonationKingLogic.isCurrentSeasonChallenge(self, player)

end

function DonationKingLogic.isSamePlayerEntity(self, player, playerId)

end

function DonationKingLogic.nextRequestKey(self, playerId, mapId)

end

function DonationKingLogic.nextRewardClaimLockKey(self, playerId)

end

function DonationKingLogic.OnBeginPlay(self)

end

function DonationKingLogic.OnEndPlay(self)

end

function DonationKingLogic.readCurrentRankingSnapshot(self, callback)

end

function DonationKingLogic.readSnapshotCache(self, callback)

end

function DonationKingLogic.recordSnapshotResult(self, success)

end

function DonationKingLogic.refreshSnapshot(self, callback)

end

function DonationKingLogic.refreshSnapshotIfStale(self, minIntervalSeconds, callback)

end

function DonationKingLogic.refreshSnapshotLatest(self, callback)

end

function DonationKingLogic.releaseClaimableReward(self, reservation)

end

function DonationKingLogic.requestDonation(self, player, mapId, amount, callback)

end

function DonationKingLogic.reserveClaimableReward(self, player, callback)

end

function DonationKingLogic.reserveDonationKingReviewLog(self, requestKey)

end

function DonationKingLogic.resetExpiredChallenge(self, player)

end

function DonationKingLogic.scheduleDonationCloseSnapshot(self, donationCloseAt)

end

function DonationKingLogic.scheduleSnapshotRefresh(self)

end

function DonationKingLogic.startChallenge(self, player, mapId, callback)

end

function DonationKingLogic.tryLockPlayerOperation(self, playerId)

end

function DonationKingLogic.tryLockRewardClaim(self, playerId, rewardLockKey)

end

function DonationKingLogic.unlockPlayerOperation(self, playerId)

end

function DonationKingLogic.unlockRewardClaim(self, playerId, rewardLockKey)

end
