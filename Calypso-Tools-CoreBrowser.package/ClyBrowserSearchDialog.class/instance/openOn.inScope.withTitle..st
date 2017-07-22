private
openOn: anEnvironmentQuery inScope: anEnvironmentScope withTitle: dialogTitle
	self showItemsOf: anEnvironmentQuery inScope: anEnvironmentScope.

	self title: dialogTitle.

	browser openModal: self.
	itemsView detachFromDataSource.

	self cancelled ifTrue: [ CmdCommandAborted signal ]