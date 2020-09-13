class_name Types
extends Reference

enum Elements { NONE, CODE, DESIGN, ART, BUG }

const WEAKNESS_MAPPING = {
	Elements.NONE: -1,
	Elements.CODE: Elements.ART,
	Elements.ART: Elements.DESIGN,
	Elements.DESIGN: Elements.CODE,
	Elements.BUG: -1,
}
