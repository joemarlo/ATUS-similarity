# Who spends their day similar to you?

Draft of d3 here: [marlo.works/d3/ATUS_similarity/](https://www.marlo.works/d3/ATUS_similarity/)

See also: [ATUS repo](https://github.com/joemarlo/ATUS)


### Notes
- add plots of demographic distribution
  - delete old plots
  - finalize scales for count distribution (need to pivot data)
- refine string distance calculation
- create less tedious input method
  - add prototypical options then allow user to adjust?
  - rpart a model based on the modes? E.g. 20 questions to determine modal string -> then allow user to edit
- sort observations by entropy (do this in R data prep?)
- reduce down to 1 hour instead of 30min freq ?
- expand n clusters and then filter cluster to nearest 100 persons by string distance
