class_name PlayableDiscardUI extends TextureButton

var discard: PlayableDiscard

func view() -> CardWithID:
	return discard.view_top()
