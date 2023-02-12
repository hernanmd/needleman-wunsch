Class {
	#name : #BaselineOfNeedlemanWunsch,
	#superclass : #BaselineOf,
	#category : #BaselineOfNeedlemanWunsch
}

{ #category : #baselines }
BaselineOfNeedlemanWunsch >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [
			spec
				package: 'NeedlemanWunsch'			with: [ spec requires: #(PolyMath) ];
				package: 'NeedlemanWunsch-Tests'	with: [ spec requires: #(NeedlemanWunsch) ].
			spec
				group: 'Core' 						with: #('NeedlemanWunsch');
				group: 'Tests' 						with: #('NeedlemanWunsch' 'NeedlemanWunsch-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
