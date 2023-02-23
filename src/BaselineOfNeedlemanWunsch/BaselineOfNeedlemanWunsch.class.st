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
				baseline: 'PolyMathDataStructures'
				with: [ spec repository: 'github://PolyMathOrg/PolyMath-DataStructures/src' ].
			spec
				package: 'NeedlemanWunsch'			with: [ spec requires: #(PolyMathDataStructures) ];
				package: 'NeedlemanWunsch-Tests'	with: [ spec requires: #(NeedlemanWunsch) ].
			spec
				group: 'Core' 						with: #('NeedlemanWunsch');
				group: 'Tests' 						with: #('NeedlemanWunsch' 'NeedlemanWunsch-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
