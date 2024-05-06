function FeatureNovel = NorOnetime(Feature)

FeatureNovel = NormalizeCommon(OutlierElimination(Feature, 'maxmin'), 0, 1);

end