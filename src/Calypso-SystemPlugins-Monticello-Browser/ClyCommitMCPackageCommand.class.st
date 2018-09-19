"
I am a command to commit given packages.

I use Iceberg if it is repository of package. 
Otherwise I use Komitter.
"
Class {
	#name : #ClyCommitMCPackageCommand,
	#superclass : #SycPackageCommand,
	#category : #'Calypso-SystemPlugins-Monticello-Browser'
}

{ #category : #testing }
ClyCommitMCPackageCommand class >> canBeExecutedInContext: aToolContext [
	"if no packages are selected then command will commit all changes in image"
	^true
]

{ #category : #activation }
ClyCommitMCPackageCommand class >> fullBrowserMenuActivation [
	<classAnnotation>
	
	^CmdContextMenuActivation byRootGroupItemOrder: 10000 for: ClyPackageContextOfFullBrowser 
]

{ #category : #activation }
ClyCommitMCPackageCommand class >> fullBrowserShortcutActivation [
	<classAnnotation>
	
	^CmdShortcutActivation by: $s meta for: ClyGlobalContextOfFullBrowser 
]

{ #category : #accessing }
ClyCommitMCPackageCommand >> defaultMenuIconName [
	^#monticelloPackage
]

{ #category : #accessing }
ClyCommitMCPackageCommand >> defaultMenuItemName [
	^'Commit'
]

{ #category : #execution }
ClyCommitMCPackageCommand >> execute [
	| repoBrowser commitBrowser repos targetRepo |
	repoBrowser := self class environment at: #IceTipRepositoriesBrowser ifAbsent: [ 
		^ self inform: 'Iceberg 0.7 and higher is required'].
	commitBrowser := self class environment at: #IceTipCommitBrowser ifAbsent: [ 
		^ self inform: 'Iceberg 0.7 and higher is required'].
	packages ifEmpty: [ ^repoBrowser new openWithSpec ].
	
	repos := IceRepository registry select: [ :repo | 
		packages anySatisfy: [:each | repo includesPackageNamed: each name ]].
	repos ifEmpty: [ ^self inform: 'Selected packages does not managed by Iceberg'].
	targetRepo := repos size = 1 ifTrue: [ repos first ] ifFalse: [ 
		UIManager default 
			chooseFrom: (repos collect: #name) values: repos title: 'Choose repository'].
	targetRepo ifNil: [ ^self ]. 
			
	(commitBrowser onRepository: targetRepo) openWithSpec
]