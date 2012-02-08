(map [when (endmatch ".arc" _) (require:+ "humble/" _)] (dir:+ arclib* "/site/humble"))
