"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/bases/megaassets
	@language: GDscript
	@dimension: 2D || 3D
	@type: MagaAssets
	@version: 0.1.2
	@created: 2020-10-21
	@updated: 2021-07-31
"""
################################################################################## [Main class] #############################################################################
"""
	@Description: MegaAssets is a class with a multitude of very useful and interesting that the developer can use to go faster in these programming. It
		is also a "low level" library on which the modules (high level) are based to provide good performance to their users. The developer can create some
		classes, all derived from the MegaAssets class.
		NB: Never try to instantiate MegaAssets if you want to avoid making the console of your engine red.
"""
tool class_name MegaAssets, "mega_assets.svg" extends Node;

################################################################################## [Attributes] #############################################################################
const _B32: int = 0xffffffff; # Contains the B32 value.
const _U32_SHIFTS: Array = Array ([24, 16, 8, 0]); # Contains an array of values [U32 SHIFTS].
const _U64_SHIFTS: Array = Array ([56, 48, 40, 32, 24, 16, 8, 0]); # Contains an array of values [U64 SHIFTS].
const _U64_SHIFTS_INV: Array = Array ([0, 8, 16, 24, 32, 40, 48, 56]); # Contains an array of values [U64 SHIFTS INV].
# Contains all supported hex values for hashing methods.
const _ROTL64_MASK: Array = Array ([
	0xffffffffffff, 0x7fffffffffff, 0x3fffffffffff, 0x1fffffffffff, 0x0fffffffffff, 0x07ffffffffff, 0x03ffffffffff,
	0x01ffffffffff, 0x00ffffffffff, 0x007fffffffff, 0x003fffffffff, 0x001fffffffff, 0x000fffffffff, 0x0007ffffffff,
	0x0003ffffffff, 0x0001ffffffff, 0x0000ffffffff, 0x00007fffffff, 0x00003fffffff, 0x00001fffffff, 0x00000fffffff,
	0x000007ffffff, 0x000003ffffff, 0x000001ffffff, 0x000000ffffff, 0x0000007fffff, 0x0000003fffff, 0x0000001fffff,
	0x0000000fffff, 0x00000007ffff, 0x00000003ffff, 0x00000001ffff, 0x00000000ffff, 0x000000007fff, 0x000000003fff,
	0x000000001fff, 0x000000000fff, 0x0000000007ff, 0x0000000003ff, 0x0000000001ff, 0x0000000000ff, 0x00000000007f,
	0x00000000003f, 0x00000000001f, 0x00000000000f, 0x000000000007, 0x000000000003, 0x000000000001, 0x00000000ffff,
	0x000000007fff, 0x000000000003, 0x000000000001, 0x000000000fff, 0x0000000007ff, 0x0000000003ff, 0x000000000001,
	0x0000000000ff, 0x00000000007f, 0x00000000003f, 0x00000000001f, 0x00000000000f, 0x000000000007, 0x000000000003,
	0x000000000001, 0x000000000000
]);
# Contains all supported hex values on SBOX (AES encryption).
const _S_BOX = Array ([
	PoolByteArray ([0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76]),
	PoolByteArray ([0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0]),
	PoolByteArray ([0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15]),
	PoolByteArray ([0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75]),
	PoolByteArray ([0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84]),
	PoolByteArray ([0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf]),
	PoolByteArray ([0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8]),
	PoolByteArray ([0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2]),
	PoolByteArray ([0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73]),
	PoolByteArray ([0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb]),
	PoolByteArray ([0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79]),
	PoolByteArray ([0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08]),
	PoolByteArray ([0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a]),
	PoolByteArray ([0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e]),
	PoolByteArray ([0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf]),
	PoolByteArray ([0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16])
]);
# Contains all supported hex values on SBOX inverse (AES encryption).
const _S_BOX_INVERSE = Array ([
	PoolByteArray ([0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb]),
	PoolByteArray ([0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb]),
	PoolByteArray ([0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e]),
	PoolByteArray ([0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25]),
	PoolByteArray ([0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92]),
	PoolByteArray ([0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84]),
	PoolByteArray ([0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06]),
	PoolByteArray ([0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b]),
	PoolByteArray ([0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73]),
	PoolByteArray ([0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e]),
	PoolByteArray ([0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b]),
	PoolByteArray ([0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4]),
	PoolByteArray ([0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f]),
	PoolByteArray ([0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef]),
	PoolByteArray ([0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61]),
	PoolByteArray ([0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d])
]);
# Contains all supported hex values on MIX MATRIX (AES encryption).
const _MIX_MATRIX = Array ([
	PoolByteArray ([0x02, 0x03, 0x01, 0x01]), PoolByteArray ([0x01, 0x02, 0x03, 0x01]),
	PoolByteArray ([0x01, 0x01, 0x02, 0x03]), PoolByteArray ([0x03, 0x01, 0x01, 0x02])
]);
# Contains all supported hex values on MIX MATRIX INVERSE (AES encryption).
const _MIX_MATRIX_INVERSE = Array ([
	PoolByteArray ([0x0E, 0x0B, 0x0D, 0x09]), PoolByteArray ([0x09, 0x0E, 0x0B, 0x0D]),
	PoolByteArray ([0x0D, 0x09, 0x0E, 0x0B]), PoolByteArray ([0x0B, 0x0D, 0x09, 0x0E])
]);
# Contains all supported hex values on RCI (AES encryption).
const _RCI = PoolByteArray ([0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36]);
# Round constants. First 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311 (hashing method).
const _RK: Array = Array ([
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98,
	0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
	0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8,
	0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819,
	0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
	0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
	0xc67178f2
]);
# Contains the useful letters for generating name.
const _LETTERS = Dictionary ({
	"VOYELLE": PoolStringArray (['a', 'e', 'a', 'e', 'i', 'o', 'o', 'a', 'e', 'a', 'e', 'i', 'a', 'e', 'a', 'e', 'i', 'o', 'o', 'a', 'e', 'a', 'e', 'i', 'y']),
	"DOUBLE_VOYELLE": PoolStringArray (["oi", "ai", "ou", "ei", "ae", "eu", "ie", "ea"]),
	"CONSONNE": PoolStringArray (['b', 'c', 'c', 'd', 'f', 'g', 'h', 'j', 'l', 'm', 'n', 'n', 'p', 'r', 'r', 's', 't', 's', 't', 'b',
		'c', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'n', 'p', 'r', 'r', 's', 't', 's', 't', 'v', 'w', 'x', 'z']),
	"DOUBLE_CONSONNE": PoolStringArray (["mm", "nn", "st", "ch", "ll", "tt", "ss"]),
	"COMPOSE": PoolStringArray (["qu", "gu", "cc", "sc", "tr", "fr", "pr", "br", "cr", "ch", "ll", "tt", "ss", "gn"])
});
# Contains the possible transitions for generating name.
const _TRANSITION = Dictionary ({
	"INITIAL": PoolStringArray (["VOYELLE", "CONSONNE", "COMPOSE"]), "VOYELLE": PoolStringArray (["CONSONNE", "DOUBLE_CONSONNE", "COMPOSE"]),
	"DOUBLE_VOYELLE": PoolStringArray (["CONSONNE", "DOUBLE_CONSONNE", "COMPOSE"]), "CONSONNE": PoolStringArray (["VOYELLE", "DOUBLE_VOYELLE"]),
	"DOUBLE_CONSONNE": PoolStringArray (["VOYELLE", "DOUBLE_VOYELLE"]), "COMPOSE": PoolStringArray (["VOYELLE"])
});
# Contains all constants about media states.
enum MediaState {NONE = 0, PLAY = 1, PAUSE = 2, STOP = 3, LOOP = 4};
# Contains all constants about "output" function.
enum Message {NORMAL = 0, WARNING = 1, ERROR = 2};
# Contains all constants about module containers operations.
enum ContainerOperation {NONE = 0, SET = 1, ADD = 2, REMOVE = 3};
# Contains all constants about modules activity zone.
enum ActivityArea {EDITOR_ONLY = 0, RUNTIME_ONLY = 1, BOTH = 2};
# Contains all constants for security method about "serialize/deserialize" functions.
enum SecurityMethod {NONE = 0, AES = 1, ARCFOUR = 2, CHACHA = 3, BINARY = 4, HEXADECIMAL = 5, OCTAL = 6, GODOT = 7};
# Contains all constants for security level about "serialize/deserialize" functions.
enum SecurityLevel {SIMPLE = 0, NORMAL = 1, ADVANCED = 2};
# Contains all constants about "serialize/deserialize" functions.
enum Checksum {NONE = 0, MD5 = 1, SHA256 = 2};
# Contains all constants for node property about "search" functions.
enum NodeProperty {NAME = 0, GROUP = 1, TYPE = 2, ANY = 3};
# Contains all constants for encryption method about "encrypt/decrypt" functions.
enum EncryptionMethod {AES = 0, ARCFOUR = 1, CHACHA = 2};
# Contains all constants for encryption schema about "encrypt/decrypt/hash_var" functions.
enum EncryptionSchema {BASE64 = 0, HEXADECIMAL = 1, RAW = 2};
# Contains all constants for hashing method about "hash_var" function.
enum HashingMethod {SIP = 0, SHA256 = 1, HASHMAC_SHA256 = 2, GODOT_SHA256 = 3, MD5 = 4, AES = 5, ARCFOUR = 6, CHACHA = 7};
# Contains all constants for event scope about event functions.
enum WornEvents {NONE = 0, CHILDREN_ONLY = 1, PARENTS_ONLY = 2, ALL = 3};
# Contains all constants for directions about "instanciates" function.
enum Orientation {NORMAL = 0, REVERSED = 1, RANDOM = 2, ALTERNATE = 3, ALTERNATE_REVERSE = 4, PING_PONG = 5};
# Contains all constants for array convertion about "any_to_array" function.
enum DictionaryProperty {KEYS = 0, VALUES = 1, BOTH = 2};
# Contains all contants about "apply_camera_effect" function.
enum Disposal {NONE = 0, CENTER = 1, TOP = 2, RIGHT = 3, BOTTOM = 4, LEFT = 5, FORWARD = 6, BACKWARD = 7};
# Contains all contants about "apply_camera_effect" function.
enum FullMonitor {NONE = 0, HORIZONTAL = 1, VERTICAL = 2, BOTH = 3};
# Contains all contants about "apply_game_settings" function.
enum GameGrade {LOW = 0, MEDIUM = 1, HIGH = 2};
# Contains all compress mode constants for an image compression.
enum ImageCompression {NONE = 0, ETC = 1, ETC2 = 2, S3TC = 3};
# Contains all constants for an image format.
enum ImageFormat {RH = 0, RF = 1, RGH = 2, RGF = 3, RGBH = 4, RGBF = 5, RGBAH = 6, RGBAF = 7, RGBA4444 = 8, RGBA5551 = 9, RGBE9995 = 10};
# Contains all constants for game data manager.
enum GameDataManager {NONE = 0, GAME_SAVES = 1, GAME_CONFIGS = 2};
# Contains all constants about mains system folders.
enum Path {
	GAME_LOCATION = 0, OS_ROOT = 1, USER_DATA = 2, USER_ROOT = 3, USER_DESKTOP = 4, USER_PICTURES = 5, USER_MUSIC = 6, USER_VIDEOS = 7,
	USER_DOCUMENTS = 8, USER_DOWNLOADS = 9
}
# Contains all contants about naughty attributes manager.
enum NaughtyAttributes {
	INPUT_MAP = 0, SIGNALS = 1, TAGS = 2, METHODS = 3, TYPES = 4, OPERATORS = 5, MOUSE_CONTROLS = 6,
	GAMEPAD_CONTROLS = 7, DESKTOP_RESOLUTIONS = 8, IPAD_RESOLUTIONS = 9, IPHONE_RESOLUTIONS = 10,
	ANDROID_RESOLUTIONS = 11, KEYBOARD_CONTROLS = 12, SYSTEM_DIR = 13, GAME_CONTROLLERS = 14,
};
# Contains all contants about "apply_camera_effect" function.
enum CameraEffect {
	NONE = 0, SIMLE_BLUR = 1, VIGNETTE = 2, PIXELIZE = 3, WHIRL = 4, SEPIA = 5, NEGATIVE = 6, CONTRASTED = 7,
	NORMALIZED = 8, BCS = 9, MIRAGE = 10, OLD_FILM = 11, STATIC_CRT = 12, MOSAIC = 13, LCD = 14, GAMEBOY = 15,
	TONE_COMIC = 16, INVERT = 17, TV = 18, VHS = 19, VHS_GLITCH = 20, VHS_PAUSE = 21, VHS_SIMPLE_GLITCH = 22,
	BW = 23, BETTER_CC = 24, COLOR_PRECISION = 25, GRAIN = 26, LENS_DISTORTION = 27, SHARPNESS = 28,
	SIMPLE_GRAIN = 29, RANDOM_NOISE = 30, SCANLINES = 31, GLITCH = 32, CRT_SCREEN = 33, SIMPLE_CRT = 34,
	SIMPLE_GLITCH = 35, CRT_LOTTES = 36, ABERRATION = 37, ADVANCED_MOSIC = 38, ANIMATED_NOISE = 39,
	AVERAGE = 40, BACKGROUND = 41, BINARY_CONVERSION = 42, BINARY_DEFAULT_MIX = 43, COLOR_BLINDNESS = 44,
	DEFAULT = 45, EDGE_DEFAULT_MIX = 46, EDGE_MOTION_MIX = 47, EDGE_PREWITT = 48, SIMPLE_EDGE = 49,
	EDGE_SOBEL = 50, MONOCHROME = 51, MOTION = 52, SIMPLE_MOSIC = 53
};
# Contains all contants about "apply_standard_effect" function.
enum StandardEffect {
	NONE = 0, BAKED_SPRITE_GLOW2D = 1, BILINEAR_FILTERING2D = 2, BILLBOARD2D = 3, BLUR2D = 4, CHROMATIC_ABERATION2D = 5,
	CLOUD2D = 6, COMPOSE2D = 7, CROSSHAIR2D = 8, DISSOLVE2D = 9, DISTORTION2D = 10, FADE2D = 11, FLAT_OUTLINE2D = 12,
	GAUSSIAN_BLUR2D = 13, GAUSSIAN_BLUR2D_OPTIMIZED = 14, GRADIENT2D = 15, GRADIENT_SHIFT2D = 16, GRAYSCALE2D = 17,
	INLINE2D = 18, INOUTLINE2D = 19, INVERT2D = 20, NEGATIVE2D = 21, OUTLINE2D = 22, PIXELIZE2D = 23,
	PIXEL_OUTLINE2D = 24, POINTILISM2D = 25, PSYCHADELIC2D = 26, REFLECTION2D = 27, SEPIA2D = 28, SHADOW2D = 29,
	SHINY2D = 30, SHOCKWAVE2D = 31, SIMPLE_DISSOLVE2D = 32, SOBEL_EDGE2D = 33, STACKED2D = 34, SWIRL2D = 35,
	VIGNETTE2D = 36, WATER2D = 37, XRAY_MASK2D = 38, ZOOM_BLUR2D = 39, XBRZ2D = 40, SIMPLE_FIRE2D = 41, OMNISCALE2D = 42,
	EASY_BLEND2D = 43, AVANCED_TOON3D = 44, CEL3D = 45, CLOUD3D = 46, COLOR_BLENDED3D = 47, CRISTAL3D = 48, CURVATURE3D = 49,
	DISSOLVE3D = 50, FLEXIBLE_TOON3D = 51, FORCE_FIELD3D = 52, GRADIENT3D = 53, MOSAIC3D = 54, OUTLINE3D = 55, OVERDRAW3D = 56,
	PLANET_ATMOSPHERE3D = 57, PSX_LIT3D = 58, PULSE_GLOW3D = 59, REFRACTION3D = 60, RIM3D = 61, SHOCKWAVE3D = 62,
	SIMPLE_FORCE_FIELD3D = 63, STYLIZED_LIQUID = 64, WIND3D = 65, XRAY_GLOW3D = 66, DEBANDING_MATERIAL3D = 67,
	ADVANCED_DECAL3D = 68, SIMPLE_DECAL3D = 69, SIMPLE_FIRE3D = 70, LIGHT_RAYS3D = 71, LENS_FLARE3D = 72
};
# Contains all constants about "bind_prop" function.
enum PropertyAccessMode {READ_ONLY = 0, WRITE_ONLY = 1, BOTH = 2};
# Contains all constants for modules transformations.
enum Transformation {NONE = 0, LOCATION = 1, ROTATION = 2, SCALE = 3, LOCROT = 4, LOCSCALE = 5, ROTSCALE = 6, ALL = 7};
# Contains all constants about "get_ik_look_at" function.
enum Axis {NONE = 0, X = 1, Y = 2, Z = 3, _X = 4, _Y = 5, _Z = 6, XY = 7, XZ = 8, YZ = 9, _XY = 10, _XZ = 11, _YZ = 12, XYZ = 13, _XYZ = 14};
# Contains all properties data about child of this node.
var __props__: Dictionary = Dictionary ({});
# Contains all module cash.
var __cash__: Dictionary = Dictionary ({occ_data = Array ([[1.0, 1.0], 2.0]), velocity = Vector3.ZERO, devices_list = Array ([]), queue_methods = Dictionary ({}),
	base_resolution = Vector2 (320, 240), stretch_mode = 0, stretch_aspect = 0
}) setget _unsetable_var_error;

################################################################################# [Main process] ############################################################################
"""@Description: Unsetable variables."""
func _unsetable_var_error (_new_value) -> void: self._output ("You cannot change value of this variable.", Message.ERROR);

"""@Description: ChaChaBlockCipher is a private class that provides some functions for CHACHA encryption method. All functions from this class are privated."""
class _ChaChaBlockCipher:
	# Attributes.
	var st: Array = Array ([]); var ws: Array = Array ([]); var ky: PoolByteArray = PoolByteArray ([]);
	var _is_private: bool = true setget _private; # Determines whether a method is private.

	# Setter for "is_private" variable.
	func _private (_new_value: bool) -> void: assert (false, "You cannot change value of this variable.");

	# When this class is instantiated.
	func _init () -> void:
		st.resize (16); ws.resize (16);
		for i in range (16):
			st [i] = 0; ws [i] = 0; ky.resize (64);

	# Chacha20 block method definition.
	func chacha20_block (a_ky: PoolByteArray, a_iv: PoolByteArray, a_ctr: int, a_rounds: int) -> PoolByteArray:
		# Disable private mode on private fonctions.
		_is_private = false; assert (st.size () == 16); assert (ws.size () == 16); assert (a_ky.size () == 16 || a_ky.size () == 32);
		assert (a_iv.size () ==  8 || a_iv.size () == 12 || a_iv.size () == 16);
		# Initialise state.
		var s: int = 4;
		if (a_ky.size () == 16):
			# 128 bit key..."expand 16-byte k".
			st [0] = 0x61707865; st [1] = 0x3120646e; st [2] = 0x79622d36; st [3] = 0x6b206574;
			# Insert 128-bit key twice.
			for i in range (0, 16, 4):
				st [s] = self._u8_to_u32le (a_ky [i], a_ky [(i + 1)], a_ky [(i + 2)], a_ky [(i + 3)]); st [(s + 4)] = st [s]; s += 1;
		else:
			# 256 bit key..."expand 32-byte k".
			st [0] = 0x61707865; st [1] = 0x3320646e; st [2] = 0x79622d32; st [3] = 0x6b206574;
			# Insert 256-bit key.
			for i in range (0, 32, 4):
				st [s] = self._u8_to_u32le (a_ky [i], a_ky [(i + 1)], a_ky [(i + 2)], a_ky [(i + 3)]); s += 1;
		# Counter & nonce.
		if (a_iv.size () == 8):
			# Original: 64 bit counter, 64 bit nonce.
			st [12] = (a_ctr >> 32) & _B32; st [13] = a_ctr & _B32; s = 14;
			for i in range (0, 8, 4):
				st [s] = self._u8_to_u32le (a_iv [i], a_iv [(i + 1)], a_iv [(i + 2)], a_iv [(i + 3)]); s += 1;
		elif (a_iv.size () == 12):
			# RFC7539: 32 bit counter, 96 bit nonce.
			st [12] = a_ctr & _B32; s = 13;
			for i in range (0, 12, 4):
				st [s] = self._u8_to_u32le (a_iv [i], a_iv [(i + 1)], a_iv [(i + 2)], a_iv [(i + 3)]); s += 1;
		else:
			# PRNG mode: 128 bit nonce, a_ctr is ignored.
			s = 12;
			for i in range (0, 16, 4):
				st [s] = self._u8_to_u32le (a_iv [i], a_iv [(i + 1)], a_iv [(i + 2)], a_iv [(i + 3)]); s += 1;
		# Round loop.
		for i in range (ws.size ()): ws [i] = st [i];
		for _r in range (a_rounds >> 1):
			self._qround (ws, 0, 4, 8, 12); self._qround (ws, 1, 5, 9, 13); self._qround (ws, 2, 6, 10, 14); self._qround (ws, 3, 7, 11, 15);
			self._qround (ws, 0, 5, 10, 15); self._qround (ws, 1, 6, 11, 12); self._qround (ws, 2, 7, 8, 13); self._qround (ws, 3, 4, 9, 14);
		# Create keystream.
		var ki: int = 0;
		for i in range (st.size ()):
			st [i] = (st [i] + ws [i]) & _B32; ky [ki] = (st [i] & 0xff); ky [(ki + 1)] = ((st [i] >> 8) & 0xff);
			ky [(ki + 2)] = ((st [i] >> 16) & 0xff); ky [(ki + 3)] = ((st [i] >> 24) & 0xff); ki += 4;
		# Enable private mode on private fonctions.
		_is_private = true; return ky;

	# Rotl method definition.
	func _rotl32 (n: int, r: int) -> int:
		# If the private mode is disabled.
		if !_is_private:
			# Return the final value.
			n = n & _B32; r = r & 0x1f; if (r == 0): return n; return (((n << r) & _B32) | ((n >> (32 - r)) & _B32)) & _B32;
		# Error message.
		else: assert (false, "{rotl32} method is private."); return 0;

	# Qround method definition.
	func _qround (ST: Array, a: int, b: int, c: int, d: int) -> void:
		# If the private mode is disabled.
		if !_is_private:
			ST [a] = (ST [a] + ST [b]) & _B32; ST [d] ^= ST [a]; ST [d] = self._rotl32 (ST [d], 16);
			ST [c] = (ST [c] + ST [d]) & _B32; ST [b] ^= ST [c]; ST [b] = self._rotl32 (ST [b], 12);
			ST [a] = (ST [a] + ST [b]) & _B32; ST [d] ^= ST [a]; ST [d] = self._rotl32 (ST [d], 8);
			ST [c] = (ST [c] + ST [d]) & _B32; ST [b] ^= ST [c]; ST [b] = self._rotl32 (ST [b], 7);
		# Error message.
		else: assert (false, "{qround} method is private.");

	# U8TOU32LE method definition.
	func _u8_to_u32le (a: int, b: int, c: int, d: int) -> int:
		# If the private mode is disabled.
		if !_is_private: return ((a & 0xff) | ((b & 0xff) << 8) | ((c & 0xff) << 16) | ((d & 0xff) << 24)) & _B32;
		# Error message.
		else: assert (false, "{u8_to_u32le} method is private."); return 0;

"""@Description: Encrypts a block with AES CBC encryption schema."""
static func _encrypt_block (block: Array, keys: Array) -> PoolByteArray:
	# Initialize the block.
	block = Array ([
		PoolByteArray ([block [0x00], block [0x01], block [0x02], block [0x03]]), PoolByteArray ([block [0x04], block [0x05], block [0x06], block [0x07]]),
		PoolByteArray ([block [0x08], block [0x09], block [0x0a], block [0x0b]]), PoolByteArray ([block [0x0c], block [0x0d], block [0x0e], block [0x0f]])
	]); for x in range (4): for d in range (4): block [x] [d] ^= keys [0] [x] [d];
	# Initialize input encrypting.
	for rnd in range (1, keys.size ()):
		# SubBytes.
		for u in range (4): for t in range (4): block [u] [t] = _S_BOX [(block [u] [t] / 16)] [(block [u] [t] % 16)];
		# ShiftRows.
		for i in range (1, 4):
			# Contains some news raows and generate some row(s).
			var new_row = PoolByteArray ([]); new_row.resize (4); for r in range (4): new_row [r] = block [((r + i) % 4)] [i];
			for e in range (4): block [e] [i] = new_row [e];
		# Mix columns and add round keys.
		if rnd != (len (keys) - 1): _mix_columns (block, _MIX_MATRIX); for i in range (4): for j in range (4): block [i] [j] ^= keys [rnd] [i] [j];
	# Contains the encrypted block.
	var cipher_block: PoolByteArray = block [0]; for i in range (1, 4): cipher_block.append_array (block [i]); return cipher_block;

"""@Description: Generates the passed key schedule from a string format (AES encryption)."""
static func _key_schedule (key: PoolByteArray) -> Array:
	# Calculate the key width.
	var key_width: int = int (key.size () / 4.0); var rounds: int = (key_width + 6);
	var expansions: float = ceil (4.0 * (rounds + 1) / key_width); var words: Array = Array ([]);
	# Generate a key character.
	for j in range (key_width): words.append (PoolByteArray ([key [(j * 4)], key [(j * 4 + 1)], key [(j * 4 + 2)], key [(j * 4 + 3)]]));
	# Generate words with expansions.
	for m in range (1, expansions):
		# Target the preview expansion.
		var exp_prev: PoolByteArray = words [(len (words) - key_width)]; var word: PoolByteArray = words [(len (words) - 1)]; var temp: int = word [0];
		# Update the current word.
		for z in range (3): word [z] = word [(z + 1)]; word [3] = temp;
		for f in range (4): word [f] = (_S_BOX [int (word [f] / 16.0)] [(word [f] % 16)] ^ exp_prev [f]); word [0] ^= _RCI [(m - 1)]; words.append (word);
		for y in range (1, key_width):
			word = words [(len (words) - 1)]; if key_width > 6 and (y % 4) == 0: for k in range (4): word [k] = _S_BOX [int (word [k] / 16.0)] [(word [k] % 16)];
			for k in range (4): word [k] ^= words [(len (words) - key_width)] [k]; words.append (word);
	# Contains the final value of the passed key.
	var keys: Array = Array ([]);
	# Calculate key sequence.
	for g in range (rounds + 1):
		# Generate each word of the passed key.
		var key_rnd: Array = Array ([words [(g * 4)]]); for v in range (1, 4): key_rnd.append (words [(g * 4 + v)]); keys.append (key_rnd);
	# Return the final result.
	return keys;

"""@Description: Creates a mixed colunm(s) for a block and mix matrix (AES encryption)."""
static func _mix_columns (block: Array, mix_matrix: Array) -> void:
	# Starting colunms creation.
	for n in range (4):
		# Contains a column data.
		var new_column: PoolByteArray = PoolByteArray ([]); new_column.resize (4);
		for q in range (4):
			var sum: int = 0;
			for k in range (4):
				var p: int = 0; var blck: int = block [n] [k]; var mtrx: int = mix_matrix [q] [k];
				for _counter in range (8):
					if (mtrx & 1) != 0: p ^= blck; var high_bit_set: bool = (blck & 0x80) != 0;
					blck = ((blck << 1) & 0xff); if high_bit_set: (blck ^= 0x1b); mtrx >>= 1;
				sum ^= p;
			new_column [q] = sum;
		block [n] = new_column;

"""@Description: Decrypts a block with AES CBC encryption schema."""
static func _decrypt_block (block: Array, keys: Array) -> PoolByteArray:
	# Initialize block.
	block = Array ([
		PoolByteArray ([block [0x00], block [0x01], block [0x02], block [0x03]]), PoolByteArray ([block [0x04], block [0x05], block [0x06], block [0x07]]),
		PoolByteArray ([block [0x08], block [0x09], block [0x0a], block [0x0b]]), PoolByteArray ([block [0x0c], block [0x0d], block [0x0e], block [0x0f]])
	]);
	# Decode the passed block.
	for rnd in range ((keys.size () - 1), 0, -1):
		# Add round key.
		for i in range (4): for j in range (4): block [i] [j] ^= keys [rnd] [i] [j];
		# Mix columns.
		if rnd != (keys.size () - 1): _mix_columns (block, _MIX_MATRIX_INVERSE);
		# Shift rows.
		for i in range (1, 4):
			# Initialize a new row.
			var new_row: PoolByteArray = PoolByteArray ([]); new_row.resize (4);
			for j in range (4): new_row [j] = block [((j - i + 4) % 4)] [i]; for j in range (4): block [j] [i] = new_row [j];
		# Sub bytes.
		for i in range (4): for j in range (4): block [i] [j] = _S_BOX_INVERSE [(block [i] [j] / 16)] [(block [i] [j] % 16)];
	# Update the current block.
	for i in range (4): for j in range (4): block [i] [j] ^= keys [0] [i] [j]; var decrypted_block: PoolByteArray = PoolByteArray (block [0]);
	# Return the decrypted passed block.
	for i in range (1, 4): decrypted_block.append_array (block [i]); return decrypted_block;

"""@Description: This method displays a message on editor console."""
static func _output (message: String, type: int = 0) -> void:
	# Message not empty.
	if !message.empty ():
		# For the normal messages.
		if type <= Message.NORMAL: print (message);
		# For the warning messages.
		elif type == Message.WARNING:
			# Editor state.
			if Engine.editor_hint: push_warning (message);
			# Otherwise.
			else:
				# Prints the given message.
				printerr (message); push_warning (message);
		# For error messages.
		else:
			# If the game is not running.
			if Engine.editor_hint: printerr (message);
			# If the game is running.
			else:
				# Prints the given message.
				printerr (message); push_error (message); assert (false, message);

"""@Description: This method is called whether a gamepad is connected or disconnected (Naughty attributes)."""
func _on_game_controller_detected (_device: int, _connected: bool) -> void:
	# Update all dropdowns configure as game controllers list.
	for drop in self.__cash__.devices_list: self.override_prop (Dictionary ({"dropdown": {"behavior": NaughtyAttributes.GAME_CONTROLLERS}}), drop);

"""@Description: This method destroys input event about gamepad detection manager (Naughty attributes)."""
func _destroy_input_event (pname: String) -> void:
	# Removes this property whether it's not a dropdown devices.
	if self.__cash__.devices_list.has (pname): __cash__.devices_list.erase (pname);
	# Is is connected ?
	var is_connected: bool = Input.is_connected ("joy_connection_changed", self, "_on_game_controller_detected");
	# No connection has been done.
	if self.__cash__.devices_list.size () == 0 && is_connected: Input.disconnect ("joy_connection_changed", self, "_on_game_controller_detected");

"""@Description: Corrects a certains entries from the given property script variables (Naugthy attributes)."""
func _correct_data (data: Dictionary) -> Array:
	# Checks all keys.
	var checks: Array = Array ([
		data.has ("source"), data.has ("value"), data.has ("type"), data.has ("hint"), data.has ("usage"), data.has ("visible"), data.has ("stream"),
		data.has ("private"), data.has ("changed"), data.has ("index"), data.has ("duplicate"), data.has ("button"), data.has ("enabled"), data.has ("disableif"),
		data.has ("showif"), data.has ("require"), data.has ("min"), data.has ("max"), data.has ("clone"), data.has ("notification"), data.has ("attach"),
		data.has ("saveable")
	]);
	# Destroy input event.
	if checks [0]: self._destroy_input_event (data.source);
	# Check value key.
	if checks [1]: data.value = self._value_manager (data.value);
	# Check attach key.
	if checks [20]:
		# Converting attach into an array.
		data.attach = Array ([data.attach]) if not self.is_array (data.attach) else Array (data.attach);
		# Converting attach into a PoolStringArray.
		data.attach = PoolStringArray (data.attach);
	# Check title key.
	if data.has ("title") && data.title is String:
		# Configure script title.
		data.source = data.title; data.usage = PROPERTY_USAGE_CATEGORY; data.type = TYPE_NIL; data.value = null;
		checks [0] = true; checks [4] = true; checks [2] = true; checks [1] = true;
	# Check dropdown key.
	if data.has ("dropdown"):
		# Configure dropdown.
		data.type = TYPE_INT; data.hint = PROPERTY_HINT_ENUM; var is_dic: bool = data.dropdown is Dictionary;
		checks [2] = true; checks [3] = true;
		# Check dropdown behavior.
		if is_dic && data.dropdown.has ("behavior") && data.dropdown.behavior is int:
			# For InputMap behavior.
			if data.dropdown.behavior <= NaughtyAttributes.INPUT_MAP: data._hint_str = InputMap.get_actions ();
			# For Signals behavior.
			elif data.dropdown.behavior == NaughtyAttributes.SIGNALS:
				# Contains all true availables signals names on the given object.
				var filter: Array = Array ([]);
				# Filtering empty strings.
				for s in self.get_id_value_of ("name", self.get_signal_list ()):
					# Remove left and right spaces.
					s = s.lstrip (' ').rstrip (' '); if !s.empty () and !filter.has (s): filter.append (s);
				# Update dropdown to object signals list.
				data._hint_str = filter;
			# For Tags behavior.
			elif data.dropdown.behavior == NaughtyAttributes.TAGS: data._hint_str = self.get_groups ();
			# For Methods behavior.
			elif data.dropdown.behavior == NaughtyAttributes.METHODS:
				# Contains all true availables methods names on the given object.
				var filter: Array = Array ([]);
				# Filtering empty strings.
				for m in self.get_id_value_of ("name", self.get_method_list ()):
					# Remove left and right spaces and check some contraints.
					m = m.lstrip (' ').rstrip (' '); if !m.empty () and !m.begins_with ("arg") and not filter.has (m): filter.append (m);
				# Update dropdown to object methods list.
				data._hint_str = filter;
			# For data types behavior.
			elif data.dropdown.behavior == NaughtyAttributes.TYPES: data._hint_str = self.get_godot_base_types ();
			# For operators behavior.
			elif data.dropdown.behavior == NaughtyAttributes.OPERATORS: data._hint_str = self.get_godot_operators ();
			# For Mouse controls behavior.
			elif data.dropdown.behavior == NaughtyAttributes.MOUSE_CONTROLS:
				# Update dropdown to mouse controls.
				data._hint_str = self.get_mouse_controls ();
				# Check keycodes key.
				if data.dropdown.has ("keycodes") && data.dropdown.keycodes is bool && data.dropdown.keycodes: data._drop_opt = NaughtyAttributes.MOUSE_CONTROLS;
			# For GamePad controls behavior.
			elif data.dropdown.behavior == NaughtyAttributes.GAMEPAD_CONTROLS:
				# Update dropdown to gamepad controls.
				data._hint_str = self.get_joystick_controls ();
				# Check keycodes key.
				if data.dropdown.has ("keycodes") && data.dropdown.keycodes is bool && data.dropdown.keycodes: data._drop_opt = NaughtyAttributes.GAMEPAD_CONTROLS;
			# For desktop resolutions behavior.
			elif data.dropdown.behavior == NaughtyAttributes.DESKTOP_RESOLUTIONS:
				# Update dropdown to desktop resolutions.
				data._hint_str = self.get_desktop_resolutions ();
				# Check sizes key.
				if data.dropdown.has ("sizes") && data.dropdown.sizes is bool && data.dropdown.sizes: data._drop_opt = NaughtyAttributes.DESKTOP_RESOLUTIONS;
			# For ipad resolutions behavior.
			elif data.dropdown.behavior == NaughtyAttributes.IPAD_RESOLUTIONS:
				# Update dropdown to ipad resolutions.
				data._hint_str = self.get_ipad_resolutions ();
				# Check sizes key.
				if data.dropdown.has ("sizes") && data.dropdown.sizes is bool && data.dropdown.sizes: data._drop_opt = NaughtyAttributes.IPAD_RESOLUTIONS;
			# For iphone resolutions behavior.
			elif data.dropdown.behavior == NaughtyAttributes.IPHONE_RESOLUTIONS:
				# Update dropdown to iphone resolutions.
				data._hint_str = self.get_iphone_resolutions ();
				# Check sizes key.
				if data.dropdown.has ("sizes") && data.dropdown.sizes is bool && data.dropdown.sizes: data._drop_opt = NaughtyAttributes.IPHONE_RESOLUTIONS;
			# For android resolutions behavior.
			elif data.dropdown.behavior == NaughtyAttributes.ANDROID_RESOLUTIONS:
				# Update dropdown to android resolutions.
				data._hint_str = self.get_android_resolutions ();
				# Check sizes key.
				if data.dropdown.has ("sizes") && data.dropdown.sizes is bool && data.dropdown.sizes: data._drop_opt = NaughtyAttributes.ANDROID_RESOLUTIONS;
			# For keyboard controls behavior.
			elif data.dropdown.behavior == NaughtyAttributes.KEYBOARD_CONTROLS:
				# Update dropdown to keyboard controls.
				data._hint_str = self.get_keyboard_controls ();
				# Check keycodes key.
				if data.dropdown.has ("keycodes") && data.dropdown.keycodes is bool && data.dropdown.keycodes: data._drop_opt = NaughtyAttributes.KEYBOARD_CONTROLS;
			# For system directories behavior.
			elif data.dropdown.behavior == NaughtyAttributes.SYSTEM_DIR:
				# Update dropdown to system directories.
				data._hint_str = Path.keys ();
				# Check paths key.
				if data.dropdown.has ("paths") && data.dropdown.paths is bool && data.dropdown.paths: data._drop_opt = NaughtyAttributes.SYSTEM_DIR;
			# For game controllers behavior.
			else:
				# No connection has been done.
				if !Input.is_connected ("joy_connection_changed", self, "_on_game_controller_detected"):
					# Make a connection to game controllers inputs.
					if Input.connect ("joy_connection_changed", self, "_on_game_controller_detected") != OK:
						# Error message.
						self.output ("Connection error on {joy_connection_changed} event.", Message.ERROR, self);
				# The dropdowns devices cash has no source.
				if not self.__cash__.devices_list.has (data.source): __cash__.devices_list.insert (0, data.source);
				# Update dropdown to game controllers inputs list.
				data._hint_str = self.get_connected_controllers_names ();
		# Otherwise.
		else:
			# Correct dropdown input.
			data._hint_str = data.dropdown if !is_dic else ''; data._hint_str = data.dropdown.value if is_dic && data.dropdown.has ("value") else data._hint_str;
			# Convert dropdown into an array.
			data._hint_str = Array ([data._hint_str]) if !self.is_array (data._hint_str) else Array (data._hint_str);
		# Convert dropdown into a string.
		data._hint_str = PoolStringArray (data._hint_str).join (',');
	# Check button key.
	elif checks [11]:
		# Configure button.
		data.type = TYPE_BOOL; data.value = false; checks [1] = true; checks [2] = true;
	# Check range key.
	elif data.has ("range") && checks [1] && checks [2]:
		# Check variable valur type.
		if data.type == TYPE_INT || data.type == TYPE_REAL:
			# The given range value type is a vector.
			var pams: String = (str (data.range.x) + ',' + str (data.range.y)) if data.range is Vector2 || data.range is Vector3 else '';
			# Parameters is a vector.
			if not pams.empty ():
				# Configure range.
				data.hint = PROPERTY_HINT_RANGE; pams = (pams + ',' + str (data.range.z)) if data.range is Vector3 else pams; data._hint_str = pams; checks [3] = true;
	# Check hint string key.
	elif data.has ("hint_string") && data.hint_string is String: data._hint_str = data.hint_string;
	# Return the final result.
	return Array ([data, checks]);

"""@Description: Checks a single statement expression (Naugthy attributes)."""
func _check_single_condition (cond: String) -> bool:
	# Correct the passed statement expression.
	cond = cond.lstrip (' ').rstrip (' ');
	# No statement found.
	if cond.empty (): self.output ("No statement found !", Message.ERROR, self);
	# Otherwise.
	else:
		# Contains the result of all searches.
		var res: PoolIntArray = PoolIntArray ([cond.find ("<="), cond.find ('>'), cond.find (">="), cond.find ('<'), cond.count ('='), cond.find ("!=")]);
		# For "<=" and '>' operators.
		if res [0] != -1 || res [1] != -1 && res [4] == 0:
			# Get all members data from the given condition.
			var mems: Array = self._get_members (cond, '>') if res [1] != -1 else self._get_members (cond, "<=");
			# The result is detected.
			if !mems.empty () and mems [0] is Array and mems [1] is Array:
				# Support his opposite operator.
				if res [0] != -1 && !mems [2]: mems [2] = true; elif res [0] != -1 && mems [2]: mems [2] = false;
				# For a single operator.
				if mems [0] [1] and mems [1] [1]:
					if !mems [2]: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && mems [0] [0] > mems [1] [0];
					else: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && not mems [0] [0] > mems [1] [0];
				# For a complex operation.
				elif !mems [0] [1] and mems [1] [1]:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					for item in mems [0] [0]:
						if !mems [2] && typeof (item) == typeof (mems [1] [0]) && item > mems [1] [0]: return true;
						elif mems [2] && typeof (item) == typeof (mems [1] [0]) && not item > mems [1] [0]: return true;
				# For a complex operation.
				elif mems [0] [1] and !mems [1] [1]:
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [1] [0]:
						if !mems [2] && typeof (mems [0] [0]) == typeof (item) && mems [0] [0] > item: return true;
						elif mems [2] && typeof (mems [0] [0]) == typeof (item) && not mems [0] [0] > item: return true;
				# For more complex operation.
				else:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [0] [0]:
						for elmt in mems [1] [0]:
							if !mems [2] && typeof (item) == typeof (elmt) && item > elmt: return true;
							elif mems [2] && typeof (item) == typeof (elmt) && not item > elmt: return true;
		# For ">=" and '<' operators.
		elif res [2] != -1 || res [3] != -1 && res [4] == 0:
			# Get all members data from the given condition.
			var mems: Array = self._get_members (cond, '<') if res [3] != -1 else self._get_members (cond, ">=");
			# The result is detected.
			if !mems.empty () and mems [0] is Array and mems [1] is Array:
				# Support his opposite operator.
				if res [2] != -1 && !mems [2]: mems [2] = true; elif res [2] != -1 && mems [2]: mems [2] = false;
				# For a single operator.
				if mems [0] [1] and mems [1] [1]:
					if !mems [2]: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && mems [0] [0] < mems [1] [0];
					else: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && not mems [0] [0] < mems [1] [0];
				# For a complex operation.
				elif !mems [0] [1] and mems [1] [1]:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					for item in mems [0] [0]:
						if !mems [2] && typeof (item) == typeof (mems [1] [0]) && item < mems [1] [0]: return true;
						elif mems [2] && typeof (item) == typeof (mems [1] [0]) && not item < mems [1] [0]: return true;
				# For a complex operation.
				elif mems [0] [1] and !mems [1] [1]:
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [1] [0]:
						if !mems [2] && typeof (mems [0] [0]) == typeof (item) && mems [0] [0] < item: return true;
						elif mems [2] && typeof (mems [0] [0]) == typeof (item) && not mems [0] [0] < item: return true;
				# For more complex operation.
				else:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [0] [0]:
						for elmt in mems [1] [0]:
							if !mems [2] && typeof (item) == typeof (elmt) && item < elmt: return true;
							elif mems [2] && typeof (item) == typeof (elmt) && not item < elmt: return true;
		# For '=' and "!=" operators.
		elif cond.find ('=') != -1:
			# Get all members data from the given condition.
			var mems: Array = Array ([]);
			# Filtering keywords.
			if res [5] != -1: mems = self._get_members (cond, "!=");
			elif res [4] == 2: mems = self._get_members (cond, "==");
			elif res [4] == 1: mems = self._get_members (cond, '=');
			# The result is detected.
			if !mems.empty () and mems [0] is Array and mems [1] is Array:
				# Support his opposite operator.
				if res [5] != -1 && !mems [2]: mems [2] = true; elif res [5] != -1 && mems [2]: mems [2] = false;
				# For a single operator.
				if mems [0] [1] and mems [1] [1]:
					if mems [0] [0] is Dictionary && mems [1] [0] is Dictionary:
						if !mems [2]: return mems [0] [0].hash () == mems [1] [0].hash ();
						else: return not mems [0] [0].hash () == mems [1] [0].hash ();
					else:
						if !mems [2]: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && mems [0] [0] == mems [1] [0]\
							|| typeof (mems [0] [0]) == TYPE_STRING && mems [0] [0].empty () && mems [1] [0].to_lower () == "null";
						else: return typeof (mems [0] [0]) == typeof (mems [1] [0]) && not mems [0] [0] == mems [1] [0]\
							|| typeof (mems [0] [0]) == TYPE_STRING && !mems [0] [0].empty () && mems [1] [0].to_lower () == "null";
				# For a complex operation.
				elif !mems [0] [1] and mems [1] [1]:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					for item in mems [0] [0]:
						if item is Dictionary && mems [1] [0] is Dictionary:
							if !mems [2]: return item.hash () == mems [1] [0].hash (); else: return not item.hash () == mems [1] [0].hash ();
						else:
							if !mems [2] && typeof (item) == typeof (mems [1] [0]) && item == mems [1] [0]: return true;
							elif !mems [2] && typeof (item) == TYPE_STRING && item.empty () && mems [1] [0].to_lower () == "null": return true;
							elif mems [2] && typeof (item) == typeof (mems [1] [0]) && not item == mems [1] [0]: return true;
							elif mems [2] && typeof (item) == TYPE_STRING && !item.empty () && mems [1] [0].to_lower () == "null": return true;
				# For a complex operation.
				elif mems [0] [1] and !mems [1] [1]:
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [1] [0]:
						if item is Dictionary && mems [1] [0] is Dictionary:
							if !mems [2]: return item.hash () == mems [0] [0].hash ();
							else: return not item.hash () == mems [0] [0].hash ();
						else:
							if !mems [2] && typeof (mems [0] [0]) == typeof (item) && mems [0] [0] == item: return true;
							elif mems [2] && typeof (mems [0] [0]) == typeof (item) && not mems [0] [0] == item: return true;
				# For more complex operation.
				else:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					mems [1] [0] = Array ([mems [1] [0]]) if not mems [1] [0] is Array else mems [1] [0];
					for item in mems [0] [0]:
						for elmt in mems [1] [0]:
							if item is Dictionary && elmt is Dictionary:
								if !mems [2]: return item.hash () == elmt.hash ();
								else: return not item.hash () == elmt.hash ();
							else:
								if !mems [2] && typeof (item) == typeof (elmt) && item == elmt: return true;
								elif mems [2] && typeof (item) == typeof (elmt) && not item == elmt: return true;
		# For "is" operator.
		elif cond.find ("is") != -1:
			# Get all members data from the given condition.
			var mems: Array = self._get_members (cond, "is");
			# The result is detected.
			if !mems.empty () and mems [0] is Array and mems [1] is Array:
				# For a single operator.
				if mems [0] [1]:
					if mems [0] [0] is NodePath:
						if mems [1] [0] == "nodepath": return true if !mems [2] else false;
						elif mems [1] [0] == "nil": return false if !mems [2] else true;
						mems [0] [0] = self.get_node_or_null (mems [0] [0]); if mems [0] [0] == null: return false;
					if !mems [2]: return self.get_type (mems [0] [0]).to_lower () == mems [1] [0];
					else: return not self.get_type (mems [0] [0]).to_lower () == mems [1] [0];
				# For a complex operation.
				else:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					for item in mems [0] [0]:
						if item is NodePath:
							if item == "nodepath": return true if !mems [2] else false;
							elif item == "nil": return false if !mems [2] else true;
							item = self.get_node_or_null (item); if item == null: return false;
						if !mems [2] && self.get_type (item).to_lower () == mems [1] [0]: return true;
						elif mems [2] && not self.get_type (item).to_lower () == mems [1] [0]: return true;
		# For other statement.
		else:
			# Correct statement and get all members.
			cond = (cond + "=false"); var mems: Array = self._get_members (cond, '='); mems [1] = null;
			# The result is detected.
			if !mems.empty () and mems [0] is Array:
				# For a single operator.
				if mems [0] [1]:
					if !mems [2] and mems [0] [0]: return true; elif mems [2] and !mems [0] [0]: return true;
				# For a complex operation.
				else:
					mems [0] [0] = Array ([mems [0] [0]]) if not mems [0] [0] is Array else mems [0] [0];
					for item in mems [0] [0]:
						if !mems [2] && item: return true; elif mems [2] && !item: return true;
	# Return a fake value.
	return false;

"""@Description: Checks "&&", "and" keyword expression (Naugthy attributes)."""
func _check_and_keyword (cond) -> bool:
	# Contains all members seperated with "&&" or "and" statement keyword.
	cond = cond.replace ("and", "&&"); cond = cond.split ("&&"); for st in cond: if !self._check_single_condition (st): return false; return true;

"""@Description: Check "||", "or" keyword expression (Naugthy attributes)."""
func _check_or_keyword (cond) -> bool:
	# Contains all members seperated with "||", "or" statement keyword.
	cond = cond.replace ("or", "||"); cond = cond.split ("||");
	# Check statements.
	for st in cond:
		# "&&" or "and" statement keyword is detected.
		if st.find ("&&") != -1 || st.find ("and") != -1:
			# If ever a statement is true.
			if self._check_and_keyword (st): return true;
		# Otherwise.
		elif self._check_single_condition (st): return true;
	# Always return the truth.
	return false;

"""@Description: Checks a statement expression (Naugthy attributes)."""
func _check_expression (cond: String) -> bool:
	# Correct the passed statement expression.
	cond = str_replace (cond, PoolStringArray (["\n", "\t", "\a", "\b", "\r", "\v", "\f"]), '').lstrip (' ').rstrip (' ');
	# Contains "&&", "and", "||", "or" keywords position.
	var res: Array = Array ([
		cond.begins_with ("||"), cond.ends_with ("||"), cond.begins_with ("or"), cond.ends_with ("or"),
		cond.begins_with ("&&"), cond.ends_with ("&&"), cond.begins_with ("and"), cond.ends_with ("and")
	]);
	# Don't begin and end with "||", "or", "&&", "and" keywords.
	if res [0] || res [1] || res [2] || res [3] || res [4] || res [5] || res [6] || res [7]:
		# Error message.
		self.output ("Invalid statement syntax !", Message.ERROR, self); return false;
	# Otherwise.
	else:
		# For "||", "or" statement logic.
		if cond.find ("||") != -1 || cond.find ("or") != -1: return self._check_or_keyword (cond);
		# For "&&", "and" statement logic.
		elif cond.find ("&&") != -1 || cond.find ("and") != -1: return self._check_and_keyword (cond);
		# No statement logic keyword found.
		else: return self._check_single_condition (cond);

"""@Description: Returns the member statement value with additional data (Naugthy attributes)."""
func _get_member (mem: Array, idx: int):
	# Check '.' and "()" characters count.
	if mem [idx].count ('.') <= 1 && mem [idx].count ("()") <= 1:
		# Check '.' and "()" characters position.
		if !mem [idx].begins_with ('.') and !mem [idx].ends_with ('.') and !mem [idx].begins_with ("()"):
			# Getting object prefix and determimes wether the final result will dynamic or not.
			var prefix: String = self.get_object_prefix (self); var sim: bool = true;
			# No point found.
			if mem [idx].find ('.') == -1:
				# The key is not a method.
				if not mem [idx].ends_with ("()"):
					# Correct property name.
					mem [idx] = self._prop_name_accuracy (mem [idx]);
					# Script properties data.
					if self.__props__.has (mem [idx]): mem [idx] = self.__props__ [mem [idx]].value;
					# Physic script variable.
					elif not self.is_undefined (mem [idx], self): mem [idx] = self.get (mem [idx]);
					# Error message.
					else: self.output (("Undefined {" + mem [idx] + "} property on {" + prefix + "} instance."), Message.ERROR, self);
				# Otherwise.
				else: mem [idx] = self.invoke (mem [idx].split ("()") [0], Array ([]), self);
			# Otherwise.
			else:
				# Get filtered value.
				mem [idx] = Array (mem [idx].split ('.')); mem [idx] [0].lstrip (' ').rstrip (' '); mem [idx] [1].lstrip (' ').rstrip (' ');
				# The second member is an integer.
				mem [idx] [1] = int (mem [idx] [1]) if self.is_full_numbers (mem [idx] [1]) else mem [idx] [1];
				# The key is not a method.
				if not mem [idx] [0].ends_with ("()"):
					# Correct property name.
					mem [idx] [0] = self._prop_name_accuracy (mem [idx] [0]);
					# Script properties data.
					if self.__props__.has (mem [idx] [0]):
						# Is it dynamic ?
						sim = true if self.is_array (self.__props__ [mem [idx] [0]].value) && mem [idx] [1] is int else false;
						# Update members array.
						mem [idx] = self.get_id_value_of (mem [idx] [1], self.__props__ [mem [idx] [0]].value);
					# Physic script variable.
					elif not self.is_undefined (mem [idx] [0], self):
						# Is it dynamic ?
						sim = true if self.is_array (self.get (mem [idx] [0])) && mem [idx] [1] is int else false;
						# Update members array.
						mem [idx] = self.get_id_value_of (mem [idx] [1], self.get (mem [idx] [0]));
					# Error message.
					else: self.output (("Undefined {" + mem [idx] [0] + "} property on {" + prefix + "} instance."), Message.ERROR, self);
				# Otherwise.
				else:
					# Get method result value.
					var mdh = self.invoke (mem [idx] [0].split ("()") [0], Array ([]), self);
					# Is it dynamic ?
					sim = true if self.is_array (mdh) && mem [idx] [1] is int else false;
					# Get the final result value.
					mem [idx] = self.get_id_value_of (mem [idx] [1], mdh);
			# Getting the final result.
			return Array ([mem [idx], sim]);
		# Error message.
		else: self.output ("Invalid statement syntaxe !", Message.ERROR, self);
	# Error message.
	else: self.output ("Syntax error !", Message.ERROR, self); return null;

"""@Description: Returns all members with her data from the given statement expression (Naugthy attributes)."""
func _get_members (cond: String, opt: String) -> Array:
	# Don't begin and end with the given operator.
	if cond.begins_with (opt) || cond.ends_with (opt): self.output ("Invalid statement syntaxe !", Message.ERROR, self);
	# Otherwise.
	else:
		# Contains all members from the given statement.
		var mem: Array = Array (cond.split (opt));
		# Check array size.
		if mem.size () == 2:
			# Remove left and right spaces.
			mem [0] = mem [0].lstrip (' ').rstrip (' '); mem [1] = mem [1].lstrip (' ').rstrip (' ');
			# All statement members aren't empty.
			if !mem [0].empty () && !mem [1].empty ():
				# Check left statement.
				mem.append (mem [0].begins_with ('!') or mem [0].begins_with ("not"));
				mem [0] = mem [0].split ('!') [1].lstrip (' ') if mem [0].begins_with ('!') else mem [0];
				mem [0] = mem [0].split ("not") [1].lstrip (' ') if mem [0].begins_with ("not") else mem [0]; mem [0] = self._get_member (mem, 0);
				# Is it '?' defined ?
				if not mem [1].begins_with ('?'):
					# The operator is not "is" keyword.
					if opt != "is": mem [1] = Array ([self.get_variant (mem [1]), true]); else: mem [1] = Array ([mem [1].to_lower (), true]);
				# Otherwise.
				else:
					# Remove '?' character.
					mem [1] = mem [1].split ('?') [1].lstrip (' ');
					# The operator is not "is" keyword.
					if opt != "is": mem [1] = self._get_member (mem, 1); else: mem [1] = Array ([mem [1].to_lower (), true]);
				# Return the final result.
				return mem;
			# Error message.
			else: self.output ("Invalid statement syntax !", Message.ERROR, self);
		# Error message.
		else: self.output ("Syntaxe error !", Message.ERROR, self);
	# Return an empty array.
	return Array ([]);

"""@Description: Returns a corresponding key of a few property name (Naugthy attributes)."""
func _prop_name_accuracy (prop: String) -> String:
	# Checks whether the passed property name is already defined on the property(ies) manager.
	if not self.__props__.has (prop):
		# Searches the passed property into the property(ies) manager.
		for item in self.__props__: if item.to_lower ().ends_with (prop.to_lower ()): return item;
	# Returns the final result.
	return prop;

"""@Description: Gets value from a property or method name (Naugthy attributes)."""
func _value_manager (value):
	# For string format.
	if typeof (value) == TYPE_STRING:
		# Remove left and right spaces.
		value = value.lstrip (' ').rstrip (' ');
		# No errors detected.
		if value.count ('?') <= 1 && value.count ("()") <= 1:
			# The given string is a name of a method or property.
			if value.begins_with ('?'):
				# Remove '?' character letter.
				value = value.split ('?') [1].lstrip (' ');
				# Is it a method ?
				if not value.ends_with ("()"):
					# Getting object prefix.
					var prefix: String = self.get_object_prefix (self); var val: String = self._prop_name_accuracy (value);
					# The proerty is it defined ?
					if self.__props__.has (val): return self.__props__ [val].value;
					# The given property is defiened on the script variables.
					elif not self.is_undefined (value, self): return self.get (value);
					# Error message.
					else: self.output (("Undefined {" + value + "} property on {" + prefix + "} instance."), Message.ERROR, self);
				# Otherwise.
				else: return self.invoke (value.lstrip ('(').lstrip (')').split ("()") [0], Array ([]), self);
			# Assign the given value with no changement.
			else: return value;
		# Error message.
		else: self.output ("Invalid syntax !", Message.ERROR, self);
	# For dictionary format.
	elif typeof (value) == TYPE_DICTIONARY && value.has ("callback") && value.callback is String:
		# Check "parameters" key.
		if value.has ("params"):
			# Getting method parameters.
			value.params = Array ([value.params]) if !self.is_array (value.params) else Array (value.params);
			# Duplicate method parameters data.
			var parms: Array = value.params.duplicate (); for k in parms.size (): parms [k] = self._value_manager (parms [k]);
			# Return method result.
			return self.invoke (value.callback, parms, self);
		# Otherwise.
		else: return self.invoke (value.callback, Array ([]), self);
	# Assign the given value with no changement.
	else: return value;

"""@Description: Manages the given configurations about require and notification keys (Naugthy attributes)."""
func _prop_require_notification_manager (prop: String, cfg: Dictionary, what: int) -> void:
	# Search what key.
	var wht: int = -1; if what >= 0: wht = cfg.what if cfg.has ("what") && cfg.what is int else -1;
	# Check actions key presence.
	if cfg.has ("actions"):
		# Statement is not empty.
		if cfg.has ("statement") && cfg.statement is String:
			# Check developper statement.
			if self._check_expression (cfg.statement):
				# For require and notification option.
				if what < 0 or what >= 0 && what == wht: self._actions_manager (cfg.actions, prop);
		# Otherwise.
		else:
			# For require option.
			if what < 0 && self.__props__ [prop].value == self.__props__ [prop].oldvalue: self._actions_manager (cfg.actions, prop);
			# For notification option.
			elif what >= 0 && what == wht: self._actions_manager (cfg.actions, prop);

"""@Description: Manages all given actions from keys configurations (Naugthy attributes)."""
func _actions_manager (actions, prop: String) -> void:
	# Getting object prefix and converting configurations data into an data array.
	var prefix: String = self.get_object_prefix (self); actions = Array ([actions]) if not actions is Array else actions;
	# Run all configurations.
	for cfg in actions:
		# The current configuration is a dictionary.
		if cfg is Dictionary:
			# Search message key.
			if cfg.has ("message") && cfg.message is String:
				# Search type key.
				if cfg.has ("type") && cfg.type is int: self._output ((prefix + " -> " + prop + ": " + cfg.message), cfg.type);
				# Error message configurations.
				else: self._output ((prefix + " -> " + prop + ": " + cfg.message), Message.ERROR);
			# Check "slot" key on the given dictionary.
			if cfg.has ("slot") && cfg.slot is String:
				# Correct the given slot name.
				cfg.slot = str_replace (cfg.slot, PoolStringArray (["\n", "\t", "\a", "\b", "\r", "\v", "\f"]), '').lstrip (' ').rstrip (' ');
				# Is it a method ?
				if not cfg.slot.ends_with ("()"):
					# Search the real property name.
					cfg.slot = self._prop_name_accuracy (cfg.slot);
					# The value key is defined.
					if cfg.has ("value"):
						# Check property existance.
						if self.__props__.has (cfg.slot):
							# The property value isn't a dictionary.
							if not cfg.value is Dictionary && typeof (cfg.value) == typeof (self.__props__ [cfg.slot].value):
								# The current value isn't equal to his old value.
								if cfg.value != self.__props__ [cfg.slot].value: self.override_prop (Dictionary ({value = cfg.value}), cfg.slot);
							# Override the target property with the given configurations.
							elif cfg.value is Dictionary: self.override_prop (cfg.value.duplicate (), cfg.slot);
						# The given property is defiened on the script variables.
						elif not self.is_undefined (cfg.slot, self): self.set (cfg.slot, cfg.value);
						# Otherwise.
						else: self.output (("Undefined {" + cfg.slot + "} property on {" + prefix + "} instance."), Message.ERROR, self);
				# Otherwise.
				else:
					# The method has no parameters.
					if !cfg.has ("params"): self.invoke (cfg.slot.lstrip ('(').lstrip (')').split ("()") [0], Array ([]), self);
					# Otherwise.
					else:
						# Correct method parameters.
						cfg.params = Array (cfg.params) if self.is_array (cfg.params) else Array ([cfg.params]);
						# Duplicate method parameters data and then search and run each special keyword.
						var parms: Array = cfg.params.duplicate (); for m in parms.size (): parms [m] = self._value_manager (parms [m]);
						# Calls the given method with his name.
						self.invoke (cfg.slot.lstrip ('(').lstrip (')').split ("()") [0], parms, self);

"""@Description: Runs module property constraints configurations (Naughty attributes)."""
func _run_constraints (prop: String):
	# The given property is ti defined ?
	if self.__props__.has (prop):
		# For disableif option.
		if self.__props__ [prop].disableif != null:
			# Boolean type.
			if self.__props__ [prop].disableif is bool: self.__props__ [prop].enabled = !self.__props__ [prop].disableif;
			# String type.
			elif self.__props__ [prop].disableif is String: self.__props__ [prop].enabled = !self._check_expression (self.__props__ [prop].disableif);
			# Dictionary type.
			elif self.__props__ [prop].disableif is Dictionary && self.__props__ [prop].disableif.has ("statement"):
				# For boolean type.
				if self.__props__ [prop].disableif.statement is bool: self.__props__ [prop].enabled = !self.__props__ [prop] [prop].disableif.statement;
				# For string type.
				elif self.__props__ [prop].disableif.statement is String:
					# Check developper statement expression.
					self.__props__ [prop].enabled = !self._check_expression (self.__props__ [prop].disableif.statement);
					# Whether the given condition is true.
					if !self.__props__ [prop].enabled && self.__props__ [prop].disableif.has ("actions"):
						# Runs the given actions.
						self._actions_manager (self.__props__ [prop].disableif.actions, prop);
		# For showif option.
		if self.__props__ [prop].showif != null:
			# Contains the old visibility value.
			var old_visible: bool = self.__props__ [prop].visible;
			# Boolean type.
			if self.__props__ [prop].showif is bool: self.__props__ [prop].visible = self.__props__ [prop].showif;
			# String type.
			elif self.__props__ [prop].showif is String: self.__props__ [prop].visible = self._check_expression (self.__props__ [prop].showif);
			# Dictionary type.
			elif self.__props__ [prop].showif is Dictionary && self.__props__ [prop].showif.has ("statement"):
				# For boolean type.
				if self.__props__ [prop].showif.statement is bool: self.__props__ [prop].visible = self.__props__ [prop].showif.statement;
				# For string type.
				elif self.__props__ [prop].showif.statement is String:
					# Check developper statement expression.
					self.__props__ [prop].visible = self._check_expression (self.__props__ [prop].showif.statement);
					# Whether the given condition is true.
					if self.__props__ [prop].visible && self.__props__ [prop].showif.has ("actions"): self._actions_manager (self.__props__ [prop].showif.actions, prop);
			# Refreshes module property.
			if old_visible != self.__props__ [prop].visible: self.property_list_changed_notify ();
		# For require option.
		if self.__props__ [prop].require != null:
			# String type.
			if self.__props__ [prop].require is String:
				# The property value is equal to his old value.
				if self.__props__ [prop].value == self.__props__ [prop].oldvalue:
					# Show the passed message.
					self._output ((self.get_object_prefix (self) + " -> " + prop +  ": " + self.__props__ [prop].require), Message.ERROR);
			# Dictionary type.
			elif self.__props__ [prop].require is Dictionary: self._prop_require_notification_manager (prop, self.__props__ [prop].require, -1);
			# For an array type.
			elif self.__props__ [prop].require is Array:
				# Run all configurations about each require statement.
				for elmt in self.__props__ [prop].require: if elmt is Dictionary: self._prop_require_notification_manager (prop, elmt, -1);
		# For min option.
		if self.__props__ [prop].min != null:
			# Contains some useful data.
			var res: Array = Array ([
				self.__props__ [prop].value is int, self.__props__ [prop].value is float,
				self.__props__ [prop].min is Vector2, self.__props__ [prop].min is Vector3,
				self.__props__ [prop].min is int, self.__props__ [prop].min is float
			]);
			# Float, integer, vector2 and vector3 type.
			if res [2] || res [3] || res [4] || res [5]:
				# The property is an integer or float.
				if res [0] || res [1]:
					# The min value is a vector2 or vector3.
					if res [2] || res [3]: self.__props__ [prop].min = self.__props__ [prop].min.x;
				# Convert min value into integer.
				if res [0]: self.__props__ [prop].min = int (self.__props__ [prop].min);
				# Update the current value to the min value.
				self.__props__ [prop].value = self._prop_value_range (self.__props__ [prop].value, self.__props__ [prop].min, true, -1);
			# Dictionary type.
			elif self.__props__ [prop].min is Dictionary and self.__props__ [prop].min.has ("value"):
				# Add some data.
				res.append (self.__props__ [prop].min.value is int); res.append (self.__props__ [prop].min.value is float);
				res.append (self.__props__ [prop].min.value is Vector2); res.append (self.__props__ [prop].min.value is Vector3);
				res.append (self.__props__ [prop].min.has ("index"));
				# The given value is a number or vector.
				if res [6] || res [7] || res [8] || res [9]:
					# The property is an integer or float.
					if res [0] || res [1]:
						# The min value is a vector2 or vector3.
						if res [8] || res [9]: self.__props__ [prop].min.value = self.__props__ [prop].min.value.x;
					# Convert min value into integer.
					if res [0]: self.__props__ [prop].min.value = int (self.__props__ [prop].min.value);
					# Getting index value.
					var idx: int = self.__props__ [prop].min.index if res [10] && self.__props__ [prop].min.index is int else -1;
					# Update the current value to the min value.
					self.__props__ [prop].value = self._prop_value_range (self.__props__ [prop].value, self.__props__ [prop].min.value, true, idx);
					# Check "actions" key presence.
					if self.__props__ [prop].min.has ("actions"):
						# Only on integer and real.
						if res [0] && res [6] || res [1] && res [7] || res [0] && res [7] || res [1] && res [6]:
							# Whether the current value is set to his min value.
							if self.__props__ [prop].value == self.__props__ [prop].min.value: self._actions_manager (self.__props__ [prop].min.actions, prop);
		# For max option.
		if self.__props__ [prop].max != null:
			# Contains some useful data.
			var res: Array = Array ([
				self.__props__ [prop].value is int, self.__props__ [prop].value is float,
				self.__props__ [prop].max is Vector2, self.__props__ [prop].max is Vector3,
				self.__props__ [prop].max is int, self.__props__ [prop].max is float
			]);
			# Float, integer, vector2 and vector3 type.
			if res [2] || res [3] || res [4] || res [5]:
				# The property is an integer or float.
				if res [0] || res [1]:
					# The max value is a vector2 or vector3.
					if res [2] || res [3]: self.__props__ [prop].max = self.__props__ [prop].max.x;
				# Convert max value into integer.
				if res [0]: self.__props__ [prop].max = int (self.__props__ [prop].max);
				# Update the current value to the max value.
				self.__props__ [prop].value = self._prop_value_range (self.__props__ [prop].value, self.__props__ [prop].max, false, -1);
			# Dictionary type.
			elif self.__props__ [prop].max is Dictionary and self.__props__ [prop].max.has ("value"):
				# Add some data.
				res.append (self.__props__ [prop].max.value is int); res.append (self.__props__ [prop].max.value is float);
				res.append (self.__props__ [prop].max.value is Vector2); res.append (self.__props__ [prop].max.value is Vector3);
				res.append (self.__props__ [prop].max.has ("index"));
				# The given value is a number or vector.
				if res [6] || res [7] || res [8] || res [9]:
					# The property is an integer or float.
					if res [0] || res [1]:
						# The max value is a vector2 or vector3.
						if res [8] || res [9]: self.__props__ [prop].max.value = self.__props__ [prop].max.value.x;
					# Convert max value into integer.
					if res [0]: self.__props__ [prop].max.value = int (self.__props__ [prop].max.value);
					# Getting index value.
					var idx: int = self.__props__ [prop].max.index if res [10] && self.__props__ [prop].max.index is int else -1;
					# Update the current value to the max value with an id.
					self.__props__ [prop].value = self._prop_value_range (self.__props__ [prop].value, self.__props__ [prop].max.value, false, idx);
					# Check "actions" key presence.
					if self.__props__ [prop].max.has ("actions"):
						# Only on integer and real.
						if res [0] && res [6] || res [1] && res [7] || res [0] && res [7] || res [1] && res [6]:
							# Whether the current value is set to his max value.
							if self.__props__ [prop].value == self.__props__ [prop].max.value: self._actions_manager (self.__props__ [prop].max.actions, prop);
		# Only on dictionary and array.
		if self.__props__ [prop].type == TYPE_ARRAY && typeof (self.__props__ [prop].value) == TYPE_ARRAY\
		|| self.__props__ [prop].type == TYPE_DICTIONARY && typeof (self.__props__ [prop].value) == TYPE_DICTIONARY:
			# For clone option.
			if self.__props__ [prop].clone != null:
				# Parsing clone configurations.
				var clone_configs = Array ([self.__props__ [prop].clone]) if !is_array (self.__props__ [prop].clone) else Array (self.__props__ [prop].clone);
				# Run all clones request.
				for elmt in clone_configs: if elmt is Dictionary: self._clone_manager (elmt, prop);
		# For duplicate option.
		if self.__props__ [prop].type == TYPE_ARRAY && typeof (self.__props__ [prop].value) == TYPE_ARRAY && self.__props__ [prop].duplicate:
			# Search nil element.
			for pos in self.__props__ [prop].value.size ():
				# Getting value of the preview element from the array.
				if typeof (self.__props__ [prop].value [pos]) == TYPE_NIL: self.__props__ [prop].value [pos] = self.__props__ [prop].value [(pos - 1)];
		# For button option.
		if self.__props__ [prop].button != null && self.__props__ [prop].value:
			# For string format.
			if self.__props__ [prop].button is String: self.invoke (self.__props__ [prop].button, Array ([]), self);
			# For a dictionary format.
			elif self.__props__ [prop].button is Dictionary && self.__props__ [prop].button.has ("actions"):
				# Runs the given actions whether there are defined.
				self._actions_manager (self.__props__ [prop].button.actions, prop);
			# Enabled button.
			self.__props__ [prop].value = false;
	# Error message.
	else: self.output (("Undefined {" + prop + "} property on {" + self.get_object_prefix (self) + "} instance."), Message.ERROR, self);

"""@Description: Manages clone searcher in Dictionaries or Arrays (Naughty attributes)."""
func _clone_manager (cfgs: Dictionary, prop: String) -> void:
	# Check "actions" key existance.
	if cfgs.has ("actions"):
		# Getting the passed statement.
		var statement = (cfgs.statement if cfgs.statement is String || cfgs.statement is bool else null) if cfgs.has ("statement") else null;
		# Ckeck the given statement expression.
		statement = self._check_expression (statement) if statement is String else statement;
		# Getting limit value from the given dictionary.
		var limit: int = cfgs.limit if cfgs.has ("limit") else 1;
		# A statemnt expression exists.
		if statement != null:
			# The id and statement keys exists.
			if statement && cfgs.has ("id") && self.get_clones_of (cfgs.id, self.__props__ [prop].value, limit) != null:
				# Runs clone actions.
				self._actions_manager (cfgs.actions, prop);
		# Only id key exists.
		elif cfgs.has ("id") && self.get_clones_of (cfgs.id, self.__props__ [prop].value, limit) != null: self._actions_manager (cfgs.actions, prop);

"""@Description: Manages properties range value on integers, reals, vector2 and vector3 (Naughty attributes)."""
func _prop_value_range (val, limit, less: bool, idx: int = -1):
	# For a single integer and real.
	if typeof (val) == TYPE_INT || typeof (val) == TYPE_REAL:
		# Return the given range.
		if less: return max (limit, val); else: return min (limit, val);
	# For a Vector2.
	elif typeof (val) == TYPE_VECTOR2:
		# For min option.
		if less:
			# The min value is a vector2 or vector3.
			if limit is Vector2 || limit is Vector3:
				# Check index value.
				if idx < 0 || idx > 1: return Vector2 (max (limit.x, val.x), max (limit.y, val.y)); elif idx == 0: return Vector2 (max (limit.x, val.x), val.y);
				else: return Vector2 (val.x, max (limit.y, val.y));
			# The min value is an integer or real.
			else:
				# Check index value.
				if idx < 0 || idx > 1: return Vector2 (max (limit, val.x), max (limit, val.y)); elif idx == 0: return Vector2 (max (limit, val.x), val.y);
				else: return Vector2 (val.x, max (limit, val.y));
		# For max option.
		else:
			# The max value is a vector2 or vector3.
			if limit is Vector2 || limit is Vector3:
				# Check index value.
				if idx < 0 || idx > 1: return Vector2 (min (limit.x, val.x), min (limit.y, val.y)); elif idx == 0: return Vector2 (min (limit.x, val.x), val.y);
				else: return Vector2 (val.x, min (limit.y, val.y));
			# The max value is an integer or real.
			else:
				# Check index value.
				if idx < 0 || idx > 1: return Vector2 (min (limit, val.x), min (limit, val.y)); elif idx == 0: return Vector2 (min (limit, val.x), val.y);
				else: return Vector2 (val.x, min (limit, val.y));
	# For a vector3.
	elif typeof (val) == TYPE_VECTOR3:
		# For min option.
		if less:
			# The min value is a vector2.
			if limit is Vector2:
				# Check index value.
				if idx < 0 || idx > 1: return Vector3 (max (limit.x, val.x), max (limit.y, val.y), val.z);
				elif idx == 0: return Vector3 (max (limit.x, val.x), val.y, val.z); else: return Vector3 (val.x, max (limit.y, val.y), val.z);
			# The min value is a vector3.
			elif limit is Vector3:
				# Check index value.
				if idx < 0 || idx > 4: return Vector3 (max (limit.x, val.x), max (limit.y, val.y), max (limit.z, val.z));
				elif idx == 0: return Vector3 (max (limit.x, val.x), val.y, val.z); elif idx == 1: return Vector3 (val.x, max (limit.y, val.y), val.z);
				elif idx == 2: return Vector3 (val.x, val.y, max (limit.z, val.z)); elif idx == 3: return Vector3 (max (limit.x, val.x), val.y, max (limit.z, val.z));
				else: return Vector3 (val.x, max (limit.y, val.y), max (limit.z, val.z));
			# The min value is an integer or real.
			else:
				# Check index value.
				if idx < 0 || idx > 4: return Vector3 (max (limit, val.x), max (limit, val.y), max (limit, val.z));
				elif idx == 0: return Vector3 (max (limit, val.x), val.y, val.z); elif idx == 1: return Vector3 (val.x, max (limit, val.y), val.z);
				elif idx == 2: return Vector3 (val.x, val.y, max (limit, val.z)); elif idx == 3: return Vector3 (max (limit, val.x), val.y, max (limit, val.z));
				else: return Vector3 (val.x, max (limit, val.y), max (limit, val.z));
		# For max option.
		else:
			# The max value is a vector2.
			if limit is Vector2:
				# Check index value.
				if idx < 0 || idx > 1: return Vector3 (min (limit.x, val.x), min (limit.y, val.y), val.z);
				elif idx == 0: return Vector3 (min (limit.x, val.x), val.y, val.z); else: return Vector3 (val.x, min (limit.y, val.y), val.z);
			# The max value is a vector3.
			elif limit is Vector3:
				# Check index value.
				if idx < 0 || idx > 4: return Vector3 (min (limit.x, val.x), min (limit.y, val.y), min (limit.z, val.z));
				elif idx == 0: return Vector3 (min (limit.x, val.x), val.y, val.z); elif idx == 1: return Vector3 (val.x, min (limit.y, val.y), val.z);
				elif idx == 2: return Vector3 (val.x, val.y, min (limit.z, val.z)); elif idx == 3: return Vector3 (min (limit.x, val.x), val.y, min (limit.z, val.z));
				else: return Vector3 (val.x, min (limit.y, val.y), min (limit.z, val.z));
			# The max value is an integer or real.
			else:
				# Check index value.
				if idx < 0 || idx > 4: return Vector3 (min (limit, val.x), min (limit, val.y), min (limit, val.z));
				elif idx == 0: return Vector3 (min (limit, val.x), val.y, val.z); elif idx == 1: return Vector3 (val.x, min (limit, val.y), val.z);
				elif idx == 2: return Vector3 (val.x, val.y, min (limit, val.z)); elif idx == 3: return Vector3 (max (limit, val.x), val.y, min (limit, val.z));
				else: return Vector3 (val.x, min (limit, val.y), min (limit, val.z));
	# Otherwise.
	else: return val;

"""@Description: Is property value has changed ? (Naughty attributes)."""
func _prop_value_changed (pname: String) -> void:
	# The changed key has a value.
	if self.__props__ [pname].changed != null:
		# Call a method with no parameters.
		if self.__props__ [pname].changed is String: self.invoke (self.__props__ [pname].changed, Array ([]), self);
		# Otherwise.
		elif self.__props__ [pname].changed is Dictionary:
			# Check "callback" key into the given dictionary.
			if self.__props__ [pname].changed.has ("callback") && self.__props__ [pname].changed.callback is String:
				# The method has no parameters.
				if !self.__props__ [pname].changed.has ("params"): self.invoke (self.__props__ [pname].changed.callback, Array ([]), self);
				# Otherwise.
				else:
					# Correct method parameters.
					self.__props__ [pname].changed.params = (Array (self.__props__ [pname].changed.params)\
						if self.is_array (self.__props__ [pname].changed.params) else Array ([self.__props__ [pname].changed.params]));
					# Duplicate method parameters data.
					var params: Array = self.__props__ [pname].changed.params.duplicate ();
					# Search and run each special keyword.
					for r in params.size (): params [r] = self._value_manager (params [r]);
					# Get the current value of the current property.
					params [0] = pname if params.size () > 0 else params [0]; if params.size () > 1: params [1] = self.__props__ [pname].value;
					# Calls the given method with his name.
					self.invoke (self.__props__ [pname].changed.callback, params, self);
			# Check actions key presence.
			if self.__props__ [pname].changed.has ("actions"): self._actions_manager (self.__props__ [pname].changed.actions, pname);

"""@Description: Returns all keys data from gamepad name."""
static func _check_joy_keys (jname: String) -> Array:
	# Getting detected joystick category keywords.
	return Array ([
		jname.find ("input") != -1, jname.find ("dual") != -1, jname.find ("ps") != -1, jname.find ("shock") != -1, jname.find ("sixaxis") != -1,
		jname.find ("playstation") != -1, jname.find ("sony") != -1, jname.find ("taiko") != -1, jname.find ("drum") != -1, jname.find ('4') != -1,
		jname.find ("xbox") != -1, jname.find ("360") != -1, jname.find ("one") != -1, jname.find ("microsoft") != -1, jname.find ("nintendo") != -1,
		jname.find ("switch") != -1, jname.find ("wii") != -1, jname.find ("mega") != -1, jname.find ("joy-con") != -1, jname.find ("neogeo") != -1,
		jname.find ("genesis") != -1, jname.find ("drive") != -1, jname.find ("nunchuck") != -1
	]);

"""@Description: Apply common line configurations (LineRenderer)."""
static func _run_line_common_configs (data: Dictionary, old: Dictionary, geometry: ImmediateGeometry, points: Array, object: Spatial) -> Dictionary:
	# Getting freeze value.
	data.freeze = data.freeze if data.has ("freeze") and data.freeze is int else (Axis.NONE if old.empty () else old.freeze);
	# Getting mesh value.
	data.mesh = data.mesh if data.has ("mesh") and data.mesh is int else (Mesh.PRIMITIVE_TRIANGLES if old.empty () else old.mesh);
	# The mesh value is less than or equal to 0.
	data.mesh = Mesh.PRIMITIVE_POINTS if data.mesh <= Mesh.PRIMITIVE_POINTS else data.mesh;
	# The mesh value is greather than or equal to 6.
	data.mesh = Mesh.PRIMITIVE_TRIANGLE_FAN if data.mesh >= Mesh.PRIMITIVE_TRIANGLE_FAN else data.mesh;
	# Getting skin value.
	data.skin = data.skin if data.has ("skin") else (Color.white if old.empty () else old.skin);
	# The given skin is an instance of a SpatialMaterial or ShaderMaterial.
	if data.skin is SpatialMaterial || data.skin is ShaderMaterial: geometry.material_override = data.skin;
	# Otherwise.
	else:
		# Creating a new insatance of a SpatialMaterial.
		var skin: SpatialMaterial = SpatialMaterial.new (); skin.albedo_color = Color.white;
		# The given skin is a Color.
		skin.albedo_color = data.skin if data.skin is Color else skin.albedo_color;
		# The given skin is a Texture.
		skin.albedo_texture = data.skin if data.skin is Texture else skin.albedo_texture;
		# Update the line material.
		geometry.material_override = skin;
	# Some points have been passed.
	if not points.empty ():
		# The points size must not be less than 0.
		if points.size () < 2: return data;
		# Otherwise.
		else:
			# Getting geometry width.
			data.width = data.width if data.has ("width") else (0.004 if old.empty () else old.width);
			# Getting smooth.
			data.smooth = data.smooth if data.has ("smooth") else (5.0 if old.empty () else old.smooth);
			# Contains caps and corners smooth.
			var smooth: Vector2 = Vector2 (5.0, 5.0);
			# The given smooth is a number or a string that contains only numbers.
			if is_number (data.smooth): smooth = Vector2 (float (data.smooth), float (data.smooth));
			# The given smooth is a Vector.
			else:
				# Contains the real vector value.
				var vect = any_to_vector2 (data.smooth); smooth = vect if vect != null else smooth;
			# Getting skin scale.
			data.skinscale = data.skinscale if data.has ("skinscale") and data.skinscale is bool else (false if old.empty () else old.skinscale);
			# Contains the active scene camera.
			var camera = object.get_viewport ().get_camera (); 
			# Getting camera global transform.
			var cam_trans: Vector3 = geometry.to_local (camera.global_transform.origin if camera is Camera else Vector3.ZERO);
			# Calculate the progress step and geometry width.
			var progress_step: float = (1.0 / points.size ()); var progress = 0; var width: Vector2 = Vector2 (0.004, 0.004);
			# The given width is a number or a string that contains only numbers.
			if is_number (data.width): width = Vector2 (float (data.width), float (data.width));
			# The given width is a Vector.
			else:
				# Contains the real vector value.
				var vect = any_to_vector2 (data.width); width = vect if vect != null else width;
			# Update thickness and next thickness for each points (current and next) in for loop.
			var thickness = lerp (width.x, width.y, progress); var next_thickness = lerp (width.x, width.y, (progress + progress_step));
			# Clear all preview data and initialize line with the current mesh.
			geometry.clear (); geometry.begin (data.mesh);
			# Adding each point to immediate geometry after clearing of the preview data.
			for t in range (points.size () - 1):
				# Contains current point coordinates.
				var current_coords = _get_real_point_cords (data.freeze, points [t], object);
				# Contains the next point coordinates.
				var next_coords = _get_real_point_cords (data.freeze, points [(t + 1)], object);
				# The current coordinates and the next coordinates aren't null.
				if current_coords != null and next_coords != null:
					# Rest coordinates.
					var rest: PoolVector3Array = PoolVector3Array ([(current_coords + next_coords), (next_coords - current_coords)]);
					var ortho_nc: Vector3 = (cam_trans - (rest [0] / 2)).cross (rest [1]).normalized ();
					# Calculate the start and end points coordinates.
					var borders: PoolVector3Array = PoolVector3Array ([(ortho_nc * thickness), (ortho_nc * next_thickness)]);
					var results: PoolVector3Array = PoolVector3Array ([
						(current_coords + borders [0]), (current_coords - borders [0]), (next_coords + borders [1]), (next_coords - borders [1])
					]);
					# Should us draw geometry caps.
					if t == 0: _draw_line_caps (current_coords, next_coords, thickness, smooth.x, cam_trans, geometry);
					# Should us scale geometry texture.
					if data.skinscale:
						# Get vectors magnitude.
						var magitude: float = rest [1].length ();
						# Calculate texture scale.
						var tex_scale: PoolRealArray = PoolRealArray ([floor (magitude), (magitude - floor (magitude))]);
						geometry.set_uv (Vector2 (tex_scale [0], 0.0)); geometry.add_vertex (rest [0]); geometry.set_uv (Vector2 (-tex_scale [1], 0.0));
						geometry.add_vertex (results [2]); geometry.set_uv (Vector2 (tex_scale [0], 1.0)); geometry.add_vertex (results [1]);
						geometry.set_uv (Vector2 (-tex_scale [1], 0.0)); geometry.add_vertex (results [2]); geometry.set_uv (Vector2 (-tex_scale [1], 1.0));
						geometry.add_vertex (results [3]); geometry.set_uv (Vector2 (tex_scale [0], 1.0)); geometry.add_vertex (results [1]);
					# Otherwise.
					else:
						# Update geometry Uvs and vertex.
						geometry.set_uv (Vector2.RIGHT); geometry.add_vertex (results [0]); geometry.set_uv (Vector2.ZERO);
						geometry.add_vertex (results [2]); geometry.set_uv (Vector2.ONE); geometry.add_vertex (results [1]);
						geometry.set_uv (Vector2.ZERO); geometry.add_vertex (results [2]); geometry.set_uv (Vector2.DOWN);
						geometry.add_vertex (results [3]); geometry.set_uv (Vector2.ONE); geometry.add_vertex (results [1]);
					# Should us draw geometry caps.
					if t == (len (points) - 2): if true: _draw_line_caps (current_coords, next_coords, thickness, smooth.x, cam_trans, geometry);
					# Should us draw corners ?
					else:
						# Contains the next of the next point coordinates.
						var next_next_coords = _get_real_point_cords (data.freeze, points [(t + 2)], object);
						# For not null value.
						if next_next_coords != null:
							# Rest coordinates.
							var dist: PoolVector3Array = PoolVector3Array ([(next_coords + next_next_coords), (next_next_coords - next_coords)]);
							# Calculate corners othogonalization.
							var ortho_nn: Vector3 = ((cam_trans - (dist [0] / 2)).cross (dist [1]).normalized () * next_thickness);
							# Calculate angle dot.
							var angle_dot: float = rest [1].dot (ortho_nn);
							# The angle dot is greather than 0.
							if angle_dot > 0.0: _draw_line_corners (next_coords, results [2], (next_coords + ortho_nn), smooth.y, geometry);
							# Otherwise.
							else: _draw_line_corners (next_coords, (next_coords - ortho_nn), results [3], smooth.y, geometry);
					# Update progress and calculate the tickness and the next tickness for the next points.
					progress += progress_step; thickness = lerp (width.x, width.y, progress); next_thickness = lerp (width.x, width.y, (progress + progress_step));
			# End the drawing sequence.
			geometry.end ();
	# Return the final value.
	return data;

"""@Description: Draw line corners to increase line renderer performance (LineRenderer)."""
static func _draw_line_corners (next_coords: Vector3, start: Vector3, end: Vector3, smoothing: float, geometry: ImmediateGeometry) -> void:
	# Initialize array.
	var array: PoolVector3Array = PoolVector3Array ([]); for _v in range (smoothing + 1): array.append (Vector3.ZERO);
	array [0] = start; array [smoothing] = end; var axis: Vector3 = start.cross (end).normalized ();
	var offset: Vector3 = (start - next_coords); var angle: float = offset.angle_to (end - next_coords);
	# Calculate point axis.
	for k in range (1, smoothing): array [k] = (next_coords + offset.rotated (axis, lerp (0.0, angle, (float (k) / smoothing))));
	# Applying the given smoothing.
	for f in range (1, (smoothing + 1)):
		geometry.set_uv (Vector2 (0.0, ((f - 1) / smoothing))); geometry.add_vertex (array [(f - 1)]);
		geometry.set_uv (Vector2 (0.0, ((f - 1) / smoothing))); geometry.add_vertex (array [f]);
		geometry.set_uv (Vector2 (0.5, 0.5)); geometry.add_vertex (next_coords);

"""@Description: Draw line caps to increase line renderer performance (LineRenderer)."""
static func _draw_line_caps (current_coords: Vector3, next_coords: Vector3, thickness: float, smoothing: float, cam_trans: Vector3, geometry: ImmediateGeometry) -> void:
	# Othogonalize cordinates.
	var orthogonal: Vector3 = ((cam_trans - current_coords).cross (current_coords - next_coords).normalized () * thickness);
	# Calculate point axis.
	var axis: Vector3 = (current_coords - cam_trans).normalized (); var array: PoolVector3Array = PoolVector3Array ([]);
	# Initialize cap array.
	for _s in range (smoothing + 1): array.append (Vector3.ZERO); array [0] = (current_coords + orthogonal); array [smoothing] = (current_coords - orthogonal);
	for n in range (1, smoothing): array [n] = (current_coords + (orthogonal.rotated (axis, lerp (0.0, PI, (float (n) / smoothing)))));
	# Applying the given smoothing.
	for c in range (1, (smoothing + 1)):
		geometry.set_uv (Vector2 (0.0, (c - 1) / smoothing)); geometry.add_vertex (array [(c - 1)]);
		geometry.set_uv (Vector2 (0.0, (c - 1) / smoothing)); geometry.add_vertex (array [c]);
		geometry.set_uv (Vector2 (0.5, 0.5)); geometry.add_vertex (current_coords);

"""@Description: Searches an found the real point coordinates with developper constraints (LineRenderer)."""
static func _get_real_point_cords (freeze: int, coords, object: Spatial):
	# Getting the real node.
	coords = object.get_node_or_null (coords) if coords is String or coords is NodePath else coords;
	# For a Spatial node.
	if coords is Spatial:
		var x: float = 0.0 if freeze == Axis.X || freeze == Axis.XY || freeze == Axis.XZ || freeze == Axis.XYZ else coords.global_transform.origin.x;
		var y: float = 0.0 if freeze == Axis.Y || freeze == Axis.XY || freeze == Axis.YZ || freeze == Axis.XYZ else coords.global_transform.origin.y;
		var z: float = 0.0 if freeze == Axis.Z || freeze == Axis.XZ || freeze == Axis.YZ || freeze == Axis.XYZ else coords.global_transform.origin.z;
		coords = Vector3 (x, y, z); return coords;
	# For a Vector2.
	elif coords is Vector2:
		var x: float = 0.0 if freeze == Axis.X || freeze == Axis.XY || freeze == Axis.XZ || freeze == Axis.XYZ else coords.x;
		var y: float = 0.0 if freeze == Axis.Y || freeze == Axis.XY || freeze == Axis.YZ || freeze == Axis.XYZ else coords.y;
		coords = Vector3 (x, y, 0.0); return coords;
	# For a Vector3.
	elif coords is Vector3:
		var x: float = 0.0 if freeze == Axis.X || freeze == Axis.XY || freeze == Axis.XZ || freeze == Axis.XYZ else coords.x;
		var y: float = 0.0 if freeze == Axis.Y || freeze == Axis.XY || freeze == Axis.YZ || freeze == Axis.XYZ else coords.y;
		var z: float = 0.0 if freeze == Axis.Z || freeze == Axis.XZ || freeze == Axis.YZ || freeze == Axis.XYZ else coords.z;
		coords = Vector3 (x, y, z); return coords;
	# Return a null value.
	else: return null;

"""@Description: Apply common line configurations when using a raycast (LineRenderer)."""
static func _run_line_ray_common_configs (data: Dictionary, ray: RayCast, geometry: ImmediateGeometry, object: Node) -> void:
	# Getting all given actions.
	data.actions = data.actions if data.has ("actions") else Array ([]);
	# Converting actions into an array.
	data.actions = Array ([data.actions]) if !is_array (data.actions) else Array (data.actions); run_slots (data.actions, object);
	# Check destroy key.
	data.destroy = data.destroy if data.has ("destroy") and data.destroy is bool else true;
	# Disable all existing imported objects.
	for child in geometry.get_children ():
		# Check destroy key.
		if data.destroy: if ray == null: child.queue_free ();
		# Otherwise.
		else:
			# Hide imported the current and change his translation to geometry translation.
			child.visible = false; child.transform.origin = Vector3.ZERO;
	# The ray parameter is not null.
	if ray != null:
		# Getting all objects impact.
		data.impact = data.impact if data.has ("impact") else Array ([]); var impact_point: Vector3 = ray.get_collision_point ();
		# Converting impact into an array.
		data.impact = Array ([data.impact]) if !is_array (data.impact) else Array (data.impact);
		# Affect all availables objects impact.
		for obj in data.impact:
			# The object impact is a NodePath or String.
			if obj is NodePath or obj is String:
				# Getting the target node.
				var node = object.get_node_or_null (NodePath (obj)); obj = String (obj);
				# The given node is correct.
				if node is Spatial:
					# Contains the object parent.
					var node_parent: Node = node.get_parent ();
					# The parent node is it a instance of a Spatial node ?
					if node_parent is Spatial:
						# Update object local transformation.
						node.transform.origin = node_parent.to_local (impact_point);
					# Otherwise.
					else: _output (("The parent of {" + node.name + "} isn't an instance of Spatial class."), Message.ERROR);
				# The given node is a prefab.
				elif obj.ends_with (".tscn") || obj.ends_with (".scn"):
					# Generate the passed object id.
					var id: String = obj.get_file ().split ('.') [0].lstrip (' ').rstrip (' ');
					# Check whether this object is already a child of the line.
					var child = geometry.get_node_or_null (id); impact_point = geometry.to_local (impact_point);
					# Undefined node.
					if child == null:
						# Loads object.
						instanciate (Dictionary ({parent = geometry.get_path (), background = false, path = obj, position = impact_point}), object, -1.0);
						# Update the child node to check whether the target object is already loaded correctly.
						child = geometry.get_node_or_null (id);
					# The child must be an instance of a Spatial node.
					if child is Spatial:
						# Enable child visibility and update his translation.
						child.visible = true; child.translation = impact_point;
					# Otherwise.
					else: _output (("{" + child.name + "} should be an instance of Spatial class."), Message.ERROR);

"""@Description: Destroys the drew line after a certain time (LineRenderer)."""
static func _destroy_geometry_after_live (live: float, geometry: ImmediateGeometry, object: Node) -> void:
	# Waiting for line live.
	if live > 0.0:
		# Destroying line object after live and checks whether the geometry instance is valid.
		yield (object.get_tree ().create_timer (live), "timeout"); if is_instance_valid (geometry): geometry.queue_free ();

"""@Description: Manages methods inner callbacks."""
static func _callback_manager (data: Dictionary, parameters: Array, error: bool, object: Node):
	# Data size is not empty.
	if not data.empty ():
		# Getting callback name.
		data.method = data.method if data.has ("method") and data.method is String else '';
		# Getting callback source.
		data.source = data.source if data.has ("source") else object.get_path (); data.source = object.get_node_or_null (NodePath (str (data.source)));
		# Call the given callback using MegaAssets run_slot method.
		return invoke (data.method, parameters, (data.source if data.source is Node else object));
	# Otherwise.
	else:
		# Custom message.
		if error:
			# Get the last parameter element.
			var last: Dictionary = parameters [(len (parameters) - 1)]; _output (last.message, last.type);
		# Return a null value.
		return null;

"""@Description: Converts a boolean value into a bit type. Eg: binary, hex, etc..."""
static func _bool_to_bit (boolean: bool, bit: int, security: bool = true) -> String: return _string_to_bit (str (boolean), bit, security);

"""@Description: Returns a normal boolean value from his coded value."""
static func _bool_from_bit (coded_value: String, bit: int, security: bool = true) -> bool:
	# Return the final value.
	return (true if _string_from_bit (coded_value, bit, security) == "True" else false);

"""@Description: Converts an integer value into a bit type. Eg: binary, hex, etc..."""
static func _int_to_bit (integer: int, bit: int, security: bool = true) -> String:
	# If the user bit is not less than 2.
	if bit > 1:
		# Contains the sign the of the passed integer.
		var is_neg: String = '1' if integer < 0 else '0'; integer = int (abs (integer)); randomize ();
		# Contains the list of the all transformed string characters and the last value of bit determination.
		var coded_value: String = ''; var result: int = -1;
		# Converting the integer into the given bit.
		while result != 0:
			# Contains the rest of the division.
			var rest: String = str (fmod (result, bit) if result != -1 else fmod (integer, bit));
			# Filtering the rest value.
			rest = str (get_hex_symbol (int (rest), (true if randi () % 2 == 0 else false)) if bit == 16 else rest);
			# Update the result value.
			if result == -1: result = int (float (integer) / bit); else: result = int (float (result) / bit);
			# If the security is actived.
			if security: coded_value += rest;
			# Otherwise.
			else:
				# If the byte size is less than 0.
				if coded_value.empty (): coded_value += rest; else: coded_value = coded_value.insert (0, rest);
		# Return the final value.
		return (is_neg + 'b' + coded_value) if bit == 2 else (is_neg + 'x' + coded_value);
	# Warning message.
	else: _output ("The value of the bit parameter mustn't less than 2.", Message.WARNING); return "Null";

"""@Description: Returns a normal integer value from his coded value."""
static func _int_from_bit (coded_value: String, bit: int, security: bool = true) -> int:
	# Correct the coded value.
	coded_value = str_replace (coded_value, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '(', ')', '[', ']', '{', '}', ',', '.', ';', '_', '-'], '');
	# If the coded text is correct.
	if coded_value != null and not coded_value.empty ():
		# Filtering the coded value.
		var cod_val: PoolStringArray = coded_value.split ('b') if bit == 2 else coded_value.split ('x'); var decrypted_value: int = 0;
		# Check coded value division size.
		if cod_val.size () == 2 and !cod_val [0].empty () and !cod_val [1].empty ():
			# Converting the other bits into 10 bits.
			for ex in cod_val [1].length ():
				# Check the security.
				if security: decrypted_value += int (int (get_int_from_hex (cod_val [1] [ex])) * pow (bit, ex));
				# Otherwise.
				else: decrypted_value += int (int (get_int_from_hex (cod_val [1] [((ex + 1) * -1)])) * pow (bit, ex));
			# Return the final value.
			return decrypted_value if cod_val [0] == '0' else (decrypted_value * -1);
		# Otherwise.
		else: return decrypted_value;
	# Otherwise.
	else: return 0;

"""@Description: Converts a string value into a bit type. Eg: binary, hex, etc..."""
static func _string_to_bit (text: String, bit: int, security: bool = true) -> String:
	# If the user string is not null and not empty.
	if text != null and not text.empty ():
		# Contains the list of the all transformed string characters.
		var coded_value: String = '';
		# Transforming each byte into the given bit.
		for c in text.length ():
			# Contains the final result of the converting.
			var coded_byte: String = _int_to_bit (ord (text [c]), bit, security);
			# If the security is actived.
			if security: coded_value = coded_value.insert (0, (coded_byte if c == 0 else (coded_byte + ' ')));
			# Otherwise.
			else: coded_value += (coded_byte if c == 0 else (' ' + coded_byte));
			# Return the final value.
		return coded_value;
	# Return an empty value.
	else: return "Null";

"""@Description: Returns a normal string value from his coded value."""
static func _string_from_bit (coded_value: String, bit: int, security: bool = true) -> String:
	# If the coded text is not empty.
	if coded_value != null and not coded_value.empty ():
		# Contains the encryted value of the given string and the decrypted string from the decrypted bytes values.
		var coded_str: PoolStringArray = PoolStringArray ([]); var decrypted_str: String = '';
		# If the character count of coded text is great than 1 and have a space.
		coded_str = coded_value.split (' ') if len (coded_value) > 1 && coded_value.find (' ') != -1 else PoolStringArray ([coded_value]);
		# Transforming each character of the encrypted value to normal.
		for code in coded_str:
			# If the security is actived.
			if security: decrypted_str = decrypted_str.insert (0, char (_int_from_bit (code, bit, security)));
			# Otherwise.
			else: decrypted_str += char (_int_from_bit (code, bit, security));
		# Return the final value.
		return decrypted_str;
	# Return a fake value.
	else: return "Null";

"""@Description: Converts a float value into a bit type. Eg: binary, hex, etc..."""
static func _float_to_bit (real: float, bit: int, security: bool = true) -> String:
	# Contains a string format of the given real.
	var stringify_real: String = str (real);
	# If the float value doesn't contain a double.
	if stringify_real.find ('.') == -1: return _int_to_bit (int (real), bit, security);
	# Otherwise.
	else:
		# Contains each number of the given real.
		var digits: PoolStringArray = stringify_real.split ('.');
		# Return the final value.
		return (_int_to_bit (int (digits [0]), bit, security) + '.' + _int_to_bit (int (digits [1]), bit, security));

"""@Description: Returns a normal float value from his coded value."""
static func _float_from_bit (coded_value: String, bit: int, security: bool = true) -> float:
	# Correct the coded value.
	coded_value = coded_value.lstrip ('.').rstrip ('.');
	# If the code text is not empty.
	if coded_value != null and not coded_value.empty ():
		# If the float value doestn't contain a double.
		if coded_value.find ('.') == -1: return float (_int_from_bit (coded_value, bit, security));
		# Otherwise.
		else:
			# Contains each number of the given real.
			var digits: PoolStringArray = coded_value.split ('.');
			# Return the final value.
			return float (str (_int_from_bit (digits [0], bit, security)) + '.' + str (_int_from_bit (digits [1], bit, security)));
	# Return a fake value.
	else: return 0.0;

"""@Description: Converts a Vector2 into a bit type. Eg: binary, hex, etc..."""
static func _vector2_to_bit (vector2: Vector2, bit: int, security: bool = true) -> String:
	# Return the final value.
	return ('(' + _float_to_bit (vector2.x, bit, security) + ", " + _float_to_bit (vector2.y, bit, security) + ')');

"""@Description: Returns a normal Vector2 from his coded value."""
static func _vector2_from_bit (coded_value: String, bit: int, security: bool = true) -> Vector2:
	# Remove all left and right spaces.
	coded_value = coded_value.lstrip ('(').rstrip (')').replace (' ', '');
	# If the coded value is not empty.
	if coded_value != null and !coded_value.empty () and coded_value.find (',') != -1:
		# Contains all sequence values about the given vector2.
		var vect_values: PoolStringArray = coded_value.split (',');
		# Return the final value.
		return Vector2 (_float_from_bit (vect_values [0], bit, security), _float_from_bit (vect_values [1], bit, security));
	# Return a fake value.
	else: return Vector2.ZERO;

"""@Description: Converts a Vector3 into a bit type. Eg: binary, hex, etc..."""
static func _vector3_to_bit (vector3: Vector3, bit: int, security: bool = true) -> String:
	# Return the final value.
	return ('(' + _float_to_bit (vector3.x, bit, security) + ", " + _float_to_bit (vector3.y, bit, security)
		+ ", " + _float_to_bit (vector3.z, bit, security) + ')');

"""@Description: Returns a normal Vector3 from his coded value."""
static func _vector3_from_bit (coded_value: String, bit: int, security: bool = true) -> Vector3:
	# Remove all left and right spaces.
	coded_value = coded_value.lstrip ('(').rstrip (')').replace (' ', '');
	# If the coded value is not empty.
	if coded_value != null and !coded_value.empty () and coded_value.find (',') != -1:
		# Contains all sequence values about the given vector3.
		var vect_values: PoolStringArray = coded_value.split (',');
		# Contains all value that will be returned.
		var vector3: Vector3 = Vector3 (0.0, 0.0, 0.0);
		# Update the first value.
		vector3 [0] = _float_from_bit (vect_values [0], bit, security);
		# Update the second value.
		vector3 [1] = _float_from_bit (vect_values [1], bit, security);
		# Update the third value.
		if 2 < len (vect_values): vector3 [2] = _float_from_bit (vect_values [2], bit, security);
		# Return the final value.
		return vector3;
	# Return a fake value.
	else: return Vector3.ZERO;

"""@Description: Converts an array values into a bit type. Eg: binary, hex, etc..."""
static func _list_to_bit (list: Array, bit: int, security: bool = true) -> Array:
	# Contains the all encrypted values about from the given list.
	var coded_list: Array = Array ([]);
	# Encrypting all value found in the given list.
	for item in list:
		# The current item is not an array.
		if not is_array (item):
			# The current value isn't a dictionary.
			if not item is Dictionary:
				# If the key is a character.
				if item is String and item.length () == 1: item += ' ';
				# Update the coded list.
				coded_list.append (_type_to_bit (item, bit, security));
			# Otlerwise.
			else: coded_list.append (_dic_to_bit (item, bit, security));
		# Otherwise.
		else: coded_list.append (_list_to_bit (Array (item), bit, security));
	# Return the final value.
	return coded_list;

"""@Description: Returns a normal array from his coded value."""
static func _list_from_bit (coded_list: Array, bit: int, security: bool = true) -> Array:
	# Contains the all decrypted values about from the given list.
	var real_list: Array = Array ([]);
	# Decrypting the list.
	for item in coded_list:
		# The current item is not an array.
		if not item is Array:
			# The current item isn't a dictionary.
			if not item is Dictionary: real_list.append (_type_from_bit (item, bit, security));
			# Otherwise.
			else: real_list.append (_dic_from_bit (item, bit, security));
		# Otherwise.
		else: real_list.append (_list_from_bit (item, bit, security));
	# Return the final result.
	return real_list;

"""@Description: Converts a dictionary into a bit type. Eg: binary, hex, etc..."""
static func _dic_to_bit (dic: Dictionary, bit: int, security: bool = true) -> Dictionary:
	# Contains the all encrypted values about from the given dictionary.
	var coded_dic: Dictionary = Dictionary ({});
	# Encrypting each key and value.
	for key in dic.keys ():
		# Contains coded key and value.
		var encp_val = null; var encp_key = null;
		# The current value is not an array.
		if not is_array (dic [key]):
			# The current value isn't a dictionary.
			if not dic [key] is Dictionary:
				# If the value is a character.
				if dic [key] is String and dic [key].length () == 1: dic [key] += ' ';
				# Update the coded dictionary.
				encp_val = _type_to_bit (dic [key], bit, security);
			# Otherwise.
			else: encp_val = _dic_to_bit (dic [key], bit, security);
		# Otherwise.
		else: encp_val = _list_to_bit (Array (dic [key]), bit, security);
		# The current key is not an array.
		if not is_array (key):
			# The current key isn't a dictionary.
			if not key is Dictionary:
				# If the key is a character.
				if key is String and key.length () == 1: key += ' ';
				# Update the coded dictionary.
				encp_key = _type_to_bit (key, bit, security);
			# Otherwise.
			else: encp_key = _dic_to_bit (key, bit, security);
		# Otherwise.
		else: encp_key = _list_to_bit (Array (key), bit, security);
		# Update the encrypted dic.
		coded_dic [encp_key] = encp_val;
	# Return the final value.
	return coded_dic;

"""@Description: Returns a normal dictionary from his coded value."""
static func _dic_from_bit (coded_dic: Dictionary, bit: int, security: bool = true) -> Dictionary:
	# Contains the all decrypted values about from the given dictionary.
	var real_dic: Dictionary = Dictionary ({});
	# Encrypting each key and value.
	for key in coded_dic.keys ():
		# Contains decoded key and value.
		var decp_val = null; var decp_key = null;
		# If the value of the current key is Array.
		if coded_dic [key] is Array: decp_val = _list_from_bit (coded_dic [key], bit, security);
		# Otherwise.
		else:
			# The current value is a Dictionary.
			if coded_dic [key] is Dictionary: decp_val = _dic_from_bit (coded_dic [key], bit, security);
			# Otherwise.
			else: decp_val = _type_from_bit (coded_dic [key], bit, security);
		# If the current key is Array.
		if key is Array: decp_key = _list_from_bit (key, bit, security);
		# Otherwise.
		else:
			# The current key is a Dictionary.
			if key is Dictionary: decp_key = _dic_from_bit (key, bit, security);
			# Otherwise.
			else: decp_key = _type_from_bit (key, bit, security);
		# Update the decrypted dictionary.
		real_dic [decp_key] = decp_val;
	# Return the final value.
	return real_dic;

"""@Description: Converts any type into a bit type. Eg: binary, hex, etc... Pay attention ! the supported types are: Integer, Float, String, Vector2 and Vector3."""
static func _type_to_bit (type, bit: int, security: bool = true) -> String:
	# For int type value.
	if type is int: return _int_to_bit (type, bit, security);
	# For float type value.
	elif type is float: return _float_to_bit (type, bit, security);
	# For string type value.
	elif type is String: return _string_to_bit (type, bit, security);
	# For boolean type value.
	elif type is bool: return _bool_to_bit (type, bit, security);
	# For vector2 type value.
	elif type is Vector2: return _vector2_to_bit (type, bit, security);
	# For vector3 type value.
	elif type is Vector3: return _vector3_to_bit (type, bit, security);
	# For other type.
	else: return _string_to_bit (str (weakref (type)), bit, security);

"""@Description: Returns a normal value of any type from his coded value. Pay attention ! the supported types are: Integer, Float, String, Vector2 and Vector3."""
static func _type_from_bit (coded_type: String, bit: int, security: bool = true):
	# For vector type.
	if coded_type.begins_with ('(') and coded_type.ends_with (')') and coded_type.find (',') != -1:
		# Getting the length for each item.
		var size: int = len (coded_type.split (", "));
		# For vector2.
		if size == 2: return _vector2_from_bit (coded_type, bit, security);
		# For vector3.
		else: return _vector3_from_bit (coded_type, bit, security);
	# For float type.
	elif coded_type.find ('.') != -1: return _float_from_bit (coded_type, bit, security);
	# For an integer.
	elif coded_type.find ('.') == -1 and coded_type.find (' ') == -1: return _int_from_bit (coded_type, bit, security);
	# For a string.
	else:
		# Contains the decrypted value as string from his coded value.
		var decrpt_str: String = _string_from_bit (coded_type, bit, security);
		# For boolean type.
		if decrpt_str == "True" or decrpt_str == "False": return (true if decrpt_str == "True" else false);
		# For a character.
		elif decrpt_str.length () == 2: return decrpt_str.rstrip (' ');
		# For string type.
		else: return decrpt_str;

"""@Description: Manages some events as a sinple methods call."""
static func _event_manger (data: Dictionary, node: Node) -> void:
	# The current data has "event" key.
	if data.has ("event") and data.event is String and node.has_method (data.event):
		# Getting user delay.
		data.delay = float (data.delay) if data.has ("delay") && is_number (data.delay) else 0.0;
		# Waiting for user delay.
		if data.delay > 0.0 and !Engine.editor_hint: yield (node.get_tree ().create_timer (data.delay), "timeout");
		# Correct the given parameters.
		data.params = (Array (data.params) if is_array (data.params) else Array ([data.params])) if data.has ("params") else Array ([]);
		# Call the current event on the current node as a function.
		node.callv (data.event, data.params.duplicate ());

"""@Description: Sets value of a given id on a dictionary or an array."""
static func _set_id_val (id, value, input, index: int = -1, typed: bool = false, rec: bool = true, _pos: int = -1) -> Array:
	# Remove left and right spaces.
	var occ: int = _pos if _pos != -1 else -1;
	# The given input is an array.
	if input is Array:
		# Searches all availables dictionaries into array.
		for elemt in input:
			# For an array or dictionary.
			if elemt is Dictionary or elemt is Array:
				# Contains the result of this method called in other process.
				var result = _set_id_val (id, value, elemt, index, typed, true, (-1 if index < 0 else occ));
				# The passed index is greather than 0.
				if index >= 0:
					# Update the current element to the given result.
					elemt = result [0]; occ = result [1]; if occ == index: break;
				# Update the current element value.
				else: elemt = result [0];
		# Return the final result.
		return Array ([input, occ]);
	# The given input is a dictionary.
	elif input is Dictionary:
		# Search the given id.
		for elmt in input:
			# The given id is found.
			if typeof (id) == typeof (elmt) && id == elmt:
				# The passed index is less than 0.
				if index < 0: input [elmt] = value if !typed || typed and typeof (input [elmt]) == typeof (value) else input [elmt];
				# Otherwise.
				else:
					# Increase the occurence value before any treatments.
					occ += 1;
					# The current occurence is equal to the given index.
					if occ == index:
						# Update the current element value.
						input [elmt] = value if !typed || typed and typeof (input [elmt]) == typeof (value) else input [elmt]; break;
			# Is it recursive ?
			elif rec:
				# Check the value of the current element.
				if input [elmt] is Dictionary || input [elmt] is Array:
					# Contains the result of this method called in other process.
					var result = _set_id_val (id, value, input [elmt].duplicate (), index, typed, true, (-1 if index < 0 else occ));
					# The passed index is greather than 0.
					if index >= 0:
						# Update the current element to the given result.
						input [elmt] = result [0]; occ = result [1]; if occ == index: break;
					# Update the current element value.
					else: input [elmt] = result [0];
		# Return the modified input.
		return Array ([input, occ]);
	# Return the given input with no modifications.
	else: return Array ([input, occ]);

############################################################################## [Available features] #########################################################################
"""
	@Description: Returns the current data of all properties about a module.
	@Parameters:
		bool json: Do you want to get data as json format ?
"""
func get_properties_data (json: bool = false):
	# Return the current data from script properties.
	if json: return JSON.print (self.__props__, "\t"); else: return self.__props__;

"""
	@Description: Returns cash data.
	@Parameters:
		bool json: Do you want to get data as json format ?
"""
func get_cash (json: bool = false):
	# Return cash data.
	if json: return JSON.print (self.__cash__, "\t"); else: return self.__cash__;

"""
	@Description: Determinates whether a/some node(s) is/are child/ren of other(s) node(s).
	@Parameters:
		Node | Array nodes: Contains the target node(s). It's the first node(s).
		Node | Array others: Contains the second node(s).
		bool recursive: Do you want to use a recursive program to check whether a node is a child of other node ?
"""
static func is_child_of (nodes, others, recursive: bool = true) -> bool:
	# Convert "nodes" and "others" parameters to an array.
	nodes = Array ([nodes]) if not nodes is Array else nodes; others = Array ([others]) if not others is Array else others;
	# Check parameters sizes.
	if nodes.size () > 0 and others.size () > 0:
		# Search parent(s) of the given node(s) on other(s) node(s).
		for node in nodes:
			# Is it a Node ?
			if node is Node:
				# Check items in "others".
				for item in others:
					# Is it a child of the given parent ?
					if !recursive and node.get_parent () != item: return false;
					# Otherwise.
					elif recursive:
						# Contains the node parent.
						var parent = node.get_parent (); var found: bool = false;
						# While the current parent is a Node.
						while parent is Node:
							# The current is the given parent.
							if parent == item:
								# I found a parent and break the while loop.
								found = true; break;
							# Gets the parent of the current parent.
							parent = parent.get_parent ();
						# No parent found.
						if !found: return false;
			# Otherwise.
			else: return false;
		# All items are a valid nodes.
		return true;
	# Otherwise.
	else: return false;

"""
	@Description: Prints a message on the editor console. This message can be a simple, a warning or an error message.
	@Parameters:
		String message: Contains the message that will be printed on the editor console.
		int type: Contains the type of the given message. The availables values are:
			-> MegaAssets.Message.NORMAL or 0: Simple message.
			-> MegaAssets.Message.WARNING or 1: Warning message.
			-> MegaAssets.Message.ERROR or 2: Error message.
		Node object: Which knot will be considered to make the differents operations ?
		float delay: What is the timeout before printing the given message ?
"""
static func output (message: String, type: int, object: Node, delay: float = 0.0) -> void:
	# Remove left and right spaces.
	message = (get_object_prefix (object) + ": " + message.lstrip (' ').rstrip (' '));
	# Message not empty.
	if !message.empty ():
		# Waiting for user delay.
		if !Engine.editor_hint && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# For the normal messages.
		if type <= Message.NORMAL: print (message);
		# For the warning messages.
		elif type == Message.WARNING:
			# Editor state.
			if Engine.editor_hint: push_warning (message);
			# Otherwise.
			else:
				# Prints the given message.
				printerr (message); push_warning (message);
		# For error messages.
		else:
			# If the game is not running.
			if Engine.editor_hint: printerr (message);
			# If the game is running.
			else:
				# Prints the given message.
				printerr (message); push_error (message); assert (false, message);

"""
	@Description: Determinates whether a/some node(s) is/are child/ren of other node.
	@Parameters:
		Node | Array nodes: Contains the target node(s).
"""
static func is_child (nodes) -> bool:
	# Convert "nodes" parameter to an array.
	nodes = Array ([nodes]) if not nodes is Array else nodes;
	# Determinates whether the given node(s) is/are a/some child/ren.
	for node in nodes: if !node is Node or !node.get_parent () is Node: return false; return true;

"""
	@Description: Determinates whether a/some node(s) is/are a/some parent(s).
	@Parameters:
		Node | Array nodes: Contains the target node(s).
"""
static func is_parent (nodes) -> bool:
	# Convert "nodes" parameter to an array.
	nodes = Array ([nodes]) if not nodes is Array else nodes;
	# Determinates whether the given node(s) is/are a/some child/ren.
	for node in nodes: if not node is Node or node.get_child_count () == 0: return false; return true;

"""@Description: Determinates whether the game is initialised."""
static func is_game_initialised () -> bool: return Engine.get_idle_frames () > 0;

"""
	@Description: Changes parent(s) of the given node(s).
	@Parameters:
		NodePath | String | PoolStringArray nodes: Contains the node(s) path(s) that has/have a parent.
		NodePath | String | PoolStringArray nparents: Contains the new parent(s) path(s) of the target node(s).
		Node object: Which knot will be considered to make the differents operations ?
		bool reversed: Do you want to inverse treatment ?
		float delay: What is the timeout before changing parent of the given node(s) ?
		float interval: What is the timeout before each change ?
"""
static func re_parent (nodes, nparents, object: Node, reversed: bool = false, delay: float = 0.0, interval: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
	# Convert "nodes" parameter to a PoolStringArray.
	nodes = Array ([nodes]) if not is_array (nodes) else Array (nodes); nodes = PoolStringArray (nodes);
	# Convert "nparents" parameter to a PoolStringArray.
	nparents = Array ([nparents]) if not is_array (nparents) else Array (nparents); nparents = PoolStringArray (nparents);
	# Contains the new parents and node sizes.
	var sizes: PoolIntArray = PoolIntArray ([nodes.size (), nparents.size ()]);
	# The size of the first param is greater than size of the second param
	if sizes [0] >= sizes [1] and sizes [1] == 1:
		# Transform the given new parent.
		var nparent = object.get_node_or_null (nparents [0]);
		# If the new parent is a node.
		if nparent is Node:
			# Change parent of each node.
			for pos in range ((0 if !reversed else (sizes [0] - 1)), (sizes [0] if !reversed else -1), (1 if !reversed else -1)):
				# Filter each item from the node list.
				var node = object.get_node_or_null (nodes [pos]);
				# If the item is valid config.
				if node is Node:
					# Make a delay for each node.
					if !Engine.editor_hint && interval > 0.0: yield (object.get_tree ().create_timer (interval), "timeout");
					# Contains the old parent of the current node.
					var old_parent = node.get_parent ();
					# If the new parent is not equal to the old parent.
					if nparent != old_parent and not is_child_of (nparent, node, true):
						# If the the parent of the given node is not "DontDestroyOnLoad".
						if old_parent != object.get_viewport ().get_node_or_null ("DontDestroyOnLoad"):
							# Move the node to the new given parent.
							old_parent.remove_child (node); nparent.add_child (node);
						# Otherwise.
						else:
							# Is the Godot Mega Asset module.
							if not node.has_method ("is_dont_destroy_mode"):
								# Move the node to the new given parent.
								old_parent.remove_child (node); nparent.add_child (node);
							# Otherwise.
							else:
								# If the module is not dont destroy mode.
								if node.is_dont_destroy_mode () is bool and not node.is_dont_destroy_mode ():
									# Move the node to the new given parent.
									old_parent.remove_child (node); nparent.add_child (node);
								# Error message.
								else: _output (("You cannot change parent of indestructible Mega Assets module::index " + str (pos)), Message.ERROR);
				# Error message.
				else: _output (("The current node is not defined::index " + str (pos)), Message.ERROR);
		# Error message.
		else: _output ("The new parent node is not defined.", Message.ERROR);
	# The size of the first param is greater than size of the second param.
	elif sizes [0] == sizes [1]:
		# Change parent of each node.
		for idx in range ((0 if !reversed else (sizes [0] - 1)), (sizes [0] if !reversed else -1), (1 if !reversed else -1)):
			# Make a delay for each node.
			if !Engine.editor_hint && interval > 0.0: yield (object.get_tree ().create_timer (interval), "timeout");
			# Re-parent all available nodes.
			re_parent (nodes [idx], nparents [idx], object, false, -1.0, 0.0);
	# Error message.
	else: _output ("The both arrays should have the same size.", Message.ERROR);

"""
	@Description: Creates an/some indestructible node(s). This/These node(s) is/are always present when the scene changed.
	@Parameters:
		NodePath | String | PoolStringArray nodes: Contains the target node(s) path(s).
		Node obj: Which knot will be considered to make the differents operations ?
		bool reversed: Do you want to inverse treatment ?
		float delay: What is the timeout before this action ?
		float interval: What is the timeout before each definition ?
"""
static func dont_destroy_on_load (nodes, obj: Node, reversed: bool = false, delay: float = 0.0, interval: float = 0.0) -> void:
	# If the game is running.
	if not Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && not is_game_initialised (): yield (obj.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (obj.get_tree ().create_timer (delay), "timeout");
		# Containts the don't destroy container node.
		var dont_destroy_on_load_container = obj.get_viewport ().get_node_or_null ("DontDestroyOnLoad");
		# If DontDestroyNode is not defined.
		if dont_destroy_on_load_container == null:
			# Creating a new instance of Node class.
			var container: Node = Node.new (); container.name = "DontDestroyOnLoad";
			# Get out to the current scene.
			obj.get_viewport ().add_child (container); re_parent (nodes, container.get_path (), obj, reversed, -1.0, interval);
		# Get out to the current scene.
		else: re_parent (nodes, dont_destroy_on_load_container.get_path (), obj, reversed, -1.0, interval);
	# Warning message.
	else: _output ("{dont_destroy_on_load} method must be call on runtime only.", Message.WARNING);

"""
	@Description: Moves a node to other node.
	@Parameters:
		NodePath | String node: Contains the target node path.
		NodePath | String other: Contains the parent node path of the node that will be moved.
		int position: Contains the position of moved node in his parent.
		Node object: Which knot will be considered to make the differents operations ?
		float delay: What is the timeout before moving ?
"""
static func move_node (node: NodePath, other: NodePath, position: int, object: Node, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
	# Getting the target future parent nodes.
	var target_node = object.get_node_or_null (node); var future_parent = object.get_node_or_null (other);
	# If the parameters are valid.
	if target_node is Node:
		# Contient the old parent of the given node.
		var old_parent = target_node.get_parent (); var last_position: int = 0;
		# Change the parent of the given node.
		if future_parent is Node: re_parent (node, other, object, false, -1.0);
		# Change the position of the child to the given position.
		if position >= 0:
			# The other is an instance of a node.
			if !future_parent is Node || future_parent is Node && target_node.get_parent () == old_parent:
				# Calculate the last position.
				last_position = (old_parent.get_child_count () - 1);
				# Valid position.
				if is_range (position, 0, last_position): old_parent.move_child (target_node, position);
				# Otherwise.
				else: old_parent.move_child (target_node, last_position);
			# Otherwise.
			else:
				# Calculate the last position.
				last_position = (future_parent.get_child_count () - 1);
				# Valid position.
				if is_range (position, 0, last_position): future_parent.move_child (future_parent.get_child (last_position), position);
				# Otherwise.
				else: future_parent.move_child (future_parent.get_child (last_position), last_position);
	# Error message.
	else: _output ("The given node is not defined.", Message.ERROR);

"""
	@Description: Calls a method named \"mname\" with a certain time.
	@Parameters:
		String mname: Contains the method name.
		Array params: Contains all parameters of the target method.
		Object object: Contains the object instance that keep the target method.
		float delay: What is the timeout before calling the given method ? Note that if you give the reference of an object that is not
			the instance of a node, you will be exempt from using this parameter.
"""
static func invoke (mname: String, params: Array, object: Object, delay: float = 0.0):
	# Correct the given method name.
	mname = str_replace (mname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '(', ')', '[', ']', '{', '}', ',', ';', '.', '-'], '');
	# If the method name is not empty.
	if not mname.empty ():
		# Getting object prefix.
		var prefix: String = get_object_prefix (object);
		# Check method existance.
		if object.has_method (mname):
			# Waiting for user delay.
			if !Engine.editor_hint && object is Node && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
			# Return the method result whether it return something in output.
			return funcref (object, mname).call_funcv (params);
		# Error message.
		else: _output (("Undefined {" + mname + "} method on {" + prefix + "} instance."), Message.ERROR);
	# Warning message.
	else: _output ("The method name shouldn't be empty.", Message.WARNING); return null;

"""
	@Description: Calls a method named \"mname\" with a certain time at each interval.
	@Parameters:
		String mname: Contains the method name.
		Array params: Contains all params of the method.
		Object instance: Contains the object instance that keep the target method.
		int count: How many the target method will be called ?
		float interval: What is the timeout before each call ?
"""
func invoke_repeating (mname: String, params: Array = Array ([]), instance: Object = self, count: int = 1, interval: float = 0.0) -> void:
	# If the method name is not empty.
	if not mname.empty ():
		# If the given method is not defined in the dictionary.
		if !mname in self.__cash__.queue_methods: __cash__.queue_methods [mname] = [0, true];
		# If the repeat count is great than 0.
		if count > 0:
			# Waiting for user interval.
			if !Engine.editor_hint && interval > 0.0: yield (self.get_tree ().create_timer (interval), "timeout");
			# If the current repeatition is less than the given count.
			if self.__cash__.queue_methods [mname] [1] and self.__cash__.queue_methods [mname] [0] < count:
				# Calls the given method.
				self.invoke (mname, params, instance); __cash__.queue_methods [mname] [0] += 1;
				# Recalls the same function.
				self.invoke_repeating (mname, params, instance, count, interval);
			# Reset the repeating count to initial value.
			else: if __cash__.queue_methods.erase (mname): pass;
		# If the repeat count is less than 0.
		elif count < 0 and !Engine.editor_hint:
			# Waiting for a moment or user interval.
			yield (self.get_tree ().create_timer (0.001 if interval <= 0.0 else interval), "timeout");
			# If the current method is in repeating mode.
			if self.__cash__.queue_methods [mname] [1]:
				# Invoke infinite call.
				self.invoke (mname, params, instance);
				# Invoke repeating infinite call.
				self.invoke_repeating (mname, params, instance, count, interval);
			# Free the computer memory.
			else: if __cash__.queue_methods.erase (mname): pass;
		# Free the computer memory.
		else: if __cash__.queue_methods.erase (mname): pass;
	# Warning message.
	else: self._output ("The method name shouldn't be empty.", Message.WARNING);

"""
	@Description: Cancels the method in invoke repeating mode.
	@Parameters:
		String mname: Contains the method name.
		Dictionary callback: Contains information on the method to be executed when the invocation of a method has been performed.
			This dictionary supports the following keys:
			-> String | NodePath source: Contains the address from method to targeted. The presence of this key is not mandatory.
				In this case, we assumed that the referred method is on the current reference.
			-> String method: Contains the name of the method to executed. The use of this key is mandatory.
		Note that the method to be executed must have only one parameter to contain the name of the method that has been canceled.
		float delay: What is the timeout before this action ?
"""
func cancel_invoke (mname: String, callback: Dictionary = Dictionary ({}), delay: float = 0.0) -> void:
	# Correct the given method name.
	mname = str_replace (mname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '(', ')', '[', ']', '{', '}', ',', ';', '.', '-'], '');
	# If the method name is not empty.
	if not mname.empty ():
		# Waiting for user delay.
		if !Engine.editor_hint && delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
		# If the method data exists.
		if mname in self.__cash__.queue_methods:
			# Stop the invoking method.
			__cash__.queue_methods [mname] [0] = 0; __cash__.queue_methods [mname] [1] = false;
			# Call the given callback whether exists.
			_callback_manager (callback, Array ([mname]), false, self);
	# Warning message.
	else: self._output ("The method name shouldn't be empty.", Message.WARNING);

"""
	@Description: Determinates whether a method named \"mname\" is in invoke repeating mode.
	@Parameters:
		String mname: Contains the method name.
"""
func is_invoking (mname: String) -> bool:
	# Correct the given method name.
	mname = str_replace (mname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '(', ')', '[', ']', '{', '}', ',', ';', '.', '-'], '');
	# If the method name is not empty.
	if not mname.empty ():
		# Return the state of the given method name.
		return (self.__cash__.queue_methods [mname] [1] if mname in self.__cash__.queue_methods else false);
	# Warning message.
	else: self._output ("The method name shouldn't be empty.", Message.WARNING); return false;

"""
	@Description: Changes value of the given property. This one must be defined on "__props__" property.
	@Parameters:
		String pname: Contains the property name.
		Variant value: Contains the property value.
		bool wait: Do you want to wait for the event "_enter_tree" is called before the initialization and execution of different configurations
			made in the properties of the script ? Do not activate this parameter only in the following methods:
			"_init", "_set", "_get", "_get_property_list", "_notification" or "_get_configuration_warning".
		float delay: What is the timeout before changing property value ?
"""
func set_prop (pname: String, value, wait: bool = false, delay: float = 0.0) -> void:
	# Corrects the given property name.
	pname = str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
	# If the property name is not empty.
	if not pname.empty ():
		# Waiting for user delay and getting exactly key value.
		if !Engine.editor_hint && delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout"); pname = self._prop_name_accuracy (pname);
		# The given property is defined.
		if self.__props__.has (pname):
			# The property is not private.
			if !self.__props__ [pname].private:
				# If the property is write only or read and write mode.
				if self.__props__ [pname].stream == PropertyAccessMode.WRITE_ONLY || self.__props__ [pname].stream == PropertyAccessMode.BOTH:
					# Check property activation.
					if self.__props__ [pname].enabled:
						# The target type is not equal to his value.
						if self.__props__ [pname].type == TYPE_INT && typeof (self.__props__ [pname].value) == TYPE_REAL:
							# Convert to integer.
							self.__props__ [pname].value = int (self.__props__ [pname].value);
						# The target type is not equal to his value.
						elif self.__props__ [pname].type == TYPE_REAL && typeof (self.__props__ [pname].value) == TYPE_INT:
							# Convert to float.
							self.__props__ [pname].value = float (self.__props__ [pname].value);
						# The type of the given is the same with his old value.
						if typeof (self.__props__ [pname].value) == typeof (value) && hash (self.__props__ [pname].value) != hash (value):
							# Update the "__props__" data and run "changed" key configurations on enter tree.
							self.__props__ [pname].value = value; if !Engine.editor_hint and wait: yield (self, "tree_entered");
							# Don't check if property value has been changed on the first game initialisation
							if !wait or Engine.editor_hint: self._prop_value_changed (pname);
							# Some attachments are been detected.
							if self.__props__ [pname].attach != null:
								# Run constraints for all attached properties.
								for property in self.__props__ [pname].attach: self._run_constraints (self._prop_name_accuracy (property));
							# Run constraints for all availables properties.
							else: for property in self.__props__: self._run_constraints (self._prop_name_accuracy (property));
				# Otherwise.
				else: self._output (("You cannot change value of {" + pname + "} property."), Message.ERROR);
			# Error message.
			else: self._output (('{' + pname + "} property is private."), Message.ERROR);
	# Warning message.
	else: self._output ("The property name mustn't be empty.", Message.WARNING);

"""
	@Description: Gets value of the given property. This one must be defined on "__props__" property.
	@Parameters:
		String pname: Contains the property name.
		bool dropdown: To return any dropdown value as string format and other value type.
"""
func get_prop (pname: String, dropdown: bool = false):
	# Correct the given property name.
	pname = str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
	# If the property name is not empty.
	if not pname.empty ():
		# Getting exactly key value.
		pname = self._prop_name_accuracy (pname);
		# The given property is it defined ?
		if self.__props__.has (pname):
			# The property is not private.
			if !self.__props__ [pname].private:
				# If the property is readonly or read and write mode.
				if self.__props__ [pname].stream == PropertyAccessMode.READ_ONLY || self.__props__ [pname].stream == PropertyAccessMode.BOTH:
					# Is it enabled ?
					if self.__props__ [pname].enabled:
						# Check dropdown key presence.
						if dropdown && self.__props__ [pname].hint_string != null:
							# Find a comma.
							if self.__props__ [pname].hint_string.find (',') != -1:
								# Getting the current value as string format.
								var value = self.__props__ [pname].hint_string.split (',');
								# Correcting selection index.
								value = (value [self.__props__ [pname].value] if self.index_validation (self.__props__ [pname].value, len (value)) else value [0]);
								# Keycode key is defined.
								if self.__props__ [pname]._drop_opt != null:
									# For mouse and joystick option.
									if self.__props__ [pname]._drop_opt == NaughtyAttributes.MOUSE_CONTROLS\
									|| self.__props__ [pname]._drop_opt == NaughtyAttributes.GAMEPAD_CONTROLS:
										# Contains a splited string.
										value = value.split (' '); return int (value [(len (value) - 1)]);
									# Size key is defined.
									elif self.__props__ [pname]._drop_opt == NaughtyAttributes.DESKTOP_RESOLUTIONS\
									|| self.__props__ [pname]._drop_opt == NaughtyAttributes.IPAD_RESOLUTIONS\
									|| self.__props__ [pname]._drop_opt == NaughtyAttributes.IPHONE_RESOLUTIONS\
									|| self.__props__ [pname]._drop_opt == NaughtyAttributes.ANDROID_RESOLUTIONS:
										# Getting the real resolution value.
										value = value.split (' ') [1].lstrip ('(').rstrip (')').split ('x');
										# Return the final result.
										return Vector2 (int (value [0]), int (value [1]));
									# For keyboard option.
									elif self.__props__ [pname]._drop_opt == NaughtyAttributes.KEYBOARD_CONTROLS:
										# Getting keyboard keycode.
										value = value.split (' ') [1].lstrip ('(').rstrip (')'); return int (value);
									# For mains system folders.
									elif self.__props__ [pname]._drop_opt == NaughtyAttributes.SYSTEM_DIR: return self.get_os_dir (self.__props__ [pname].value);
								# Return dropdown as string format.
								else: return value;
							# Return the single value.
							else: return self.__props__ [pname].hint_string;
						# Return the property value.
						else: return (self.__props__ [pname].value.duplicate (true) if self.__props__ [pname].value is Array\
						|| self.__props__ [pname].value is Dictionary else self.__props__ [pname].value);
					# The game isn't running.
					elif !Engine.editor_hint: return self.get_initialised_type (self.__props__ [pname].value);
					# Runtime mode.
					else: return (self.__props__ [pname].value.duplicate (true) if self.__props__ [pname].value is Array\
					|| self.__props__ [pname].value is Dictionary else self.__props__ [pname].value);
				# Otherwise.
				else: self._output (("You cannot get value of {" + pname + "} property."), Message.ERROR);
			# Error message.
			else: self._output (('{' + pname + "} property is private."), Message.ERROR);
	# Warning message.
	else: self._output ("The property name mustn't be empty.", Message.WARNING);

"""
	@Description: Finds all nodes from their name/group/class name.
	@Parameters:
		String | PoolStringArray | Array id: Contains the target node(s) name(s)/group(s)/class name(s).
		Node ref: Contains the search reference.
		int prop: What is the node property that has been targeted to find the given node(s) ? The supported values are:
			-> MegaAssets.NodeProperty.NAME or 0: Finds nodes using their name.
			-> MegaAssets.NodeProperty.GROUP or 1: Finds nodes using their group name.
			-> MegaAssets.NodeProperty.TYPE or 2: Finds nodes using their class name.
			-> MegaAssets.NodeProperty.ANY or 3: Finds nodes using their class name/name/group.
		int count: How many result(s) will be returned ? If this value is less than 0, you will get all found values.
		bool inv: Do you want to inverse treatment ?
		bool rec: Do you want to use the recursive algorithm to find some nodes ?
"""
static func search (id, ref: Node, prop: int = NodeProperty.ANY, count: int = -1, inv: bool = false, rec: bool = true):
	# Checks count value.
	if count != 0:
		# Convert "id" parameter to an array. And then into a PoolStringArray.
		id = Array ([id]) if not is_array (id) else Array (id); id = PoolStringArray (id);
		# Contains all found nodes.
		var nodes: Array = Array ([]); var children: Array = ref.get_children ();
		# Searches the given nodes names.
		for c in range ((0 if !inv else (children.size () - 1)), (children.size () if !inv else -1), (1 if !inv else -1)):
			# Get out of this loop.
			if count > 0 && nodes.size () == count: break;
			# For nodes names.
			if prop <= NodeProperty.NAME and children [c].name in id: nodes.append (children [c]);
			# For nodes groups.
			elif prop == NodeProperty.GROUP:
				# If the id contains the given group name.
				for x in id: if x in children [c].get_groups (): nodes.append (children [c]);
			# For node class names.
			elif prop == NodeProperty.TYPE and children [c].get_class () in id: nodes.append (children [c]);
			# For any node.
			elif prop >= NodeProperty.ANY:
				# Try node name and class type.
				if children [c].name in id: nodes.append (children [c]); elif children [c].get_class () in id: nodes.append (children [c]);
				# Try node group.
				else:
					# If the id contains the given group name.
					for string in id: if string in children [c].get_groups (): nodes.append (children [c]);
			# Get out of this loop.
			if count > 0 && nodes.size () == count: break;
			# If the recursivity is activate.
			if rec and children [c].get_child_count () > 0:
				# Contains the found node in other process.
				var result = search (id, children [c], prop, ((count - nodes.size ()) if count > 0 else count), inv, rec);
				# If there are a node that will be found.
				if result != null:
					# If the result is an array.
					if result is Array: for item in result: nodes.append (item); else: nodes.append (result);
		# Returns the final value.
		if nodes.size () == 1: return nodes [0]; elif nodes.size () <= 0: return null; else: return nodes;
	# Return an empty value.
	else: return null;

"""
	@Description: Determinates whether a/some node(s) is/are inside in other node.
	@Parameters:
		String | PoolStringArray | Array id: Contains the target node(s) name(s)/group(s)/class name(s).
		Node | Array scope: Contains the search scope. In the array, use objects node instance only.
		int prop: What is the node property that has been targeted to find the given node(s) ? The supported values are:
			-> MegaAssets.NodeProperty.NAME or 0: Finds nodes using their name.
			-> MegaAssets.NodeProperty.GROUP or 1: Finds nodes using their group name.
			-> MegaAssets.NodeProperty.TYPE or 2: Finds nodes using their class name.
			-> MegaAssets.NodeProperty.ANY or 3: Finds nodes using their class name/name/group.
		bool rec: Do you want to use the recursive algorithm to find some nodes ?
"""
static func contains (id, scope, prop: int = NodeProperty.ANY, rec: bool = true) -> bool:
	# Convert "scope" parameter to an array.
	scope = Array ([scope]) if not scope is Array else scope;
	# Determine whether these scope contains the given node id.
	for parent in scope:
		# The current parent is not an instance of Node class.
		if not parent is Node: return false;
		# Otherwise.
		else:
			# Seach all availables ids.
			for key in id: if search (key, parent, prop, 1, false, rec) == null: return false;
	# All specified node(s) are contains in the scope.
	return true;

"""
	@Description: Determinates whether a/some node(s) can be destroyed on changing a scene. The search here isn't recursive.
	@Parameters:
		String | PoolStringArray | Array id: Contains the target node(s) id(s).
		Node object: Which knot will be considered to make the differents operations ?
		int property: What is the node property that has been targeted to find the given node(s) id(s) ? The supported values are:
			-> MegaAssets.NodeProperty.NAME or 0: Finds nodes using their name.
			-> MegaAssets.NodeProperty.GROUP or 1: Finds nodes using their group name.
			-> MegaAssets.NodeProperty.TYPE or 2: Finds nodes using their class name.
			-> MegaAssets.NodeProperty.ANY or 3: Finds nodes using their class name/name/group.
"""
static func is_indestructible (id, object: Node, property: int = NodeProperty.ANY) -> bool:
	# Contains the game viewport and one his child.
	var viewport: Viewport = object.get_viewport (); var container = viewport.get_node_or_null ("DontDestroyOnLoad");
	# Search the node id into the viewport.
	var on_viewport: bool = contains (id, viewport, property, false);
	# Search the node id into the DontDestroyOnLoad node.
	var on_dont_destroy_container: bool = contains (id, container, property, false) if container != null else false;
	# If the current node id is into the autoload section.
	return on_viewport or on_dont_destroy_container;

"""
	@Description: Finds all indestructible node(s) from their name/group/class name. The search scope here is \"DontDestroyOnLoad\" node.
	@Parameters:
		String | PoolStringArray | Array id: Contains an/some indestructible node(s) name(s)/group(s)/class name(s).
		Node obj: Which knot will be considered to make the differents operations ?
		int prop: What is the node property that has been targeted to find the given node(s) id(s) ? The supported values are:
			-> MegaAssets.NodeProperty.NAME or 0: Finds nodes using their name.
			-> MegaAssets.NodeProperty.GROUP or 1: Finds nodes using their group name.
			-> MegaAssets.NodeProperty.TYPE or 2: Finds nodes using their class name.
			-> MegaAssets.NodeProperty.ANY or 3: Finds nodes using their class name/name/group.
		int count: How many result(s) will be returned ? If this value is less than 0, you will get all found values.
		bool inv: Do you want to inverse treatment ?
		bool red: Do you want to use the recursive algorithm to find an/some indestructible node(s) ?
"""
static func get_indestructible (id, obj: Node, prop: int = NodeProperty.ANY, count: int = -1, inv: bool = false, rec: bool = true):
	# The game isn't initialized ?
	if not is_game_initialised ():
		# Getting the active scene reference.
		var active_scene = obj.get_tree ().current_scene;
		# Returns an/some indestructible node(s).
		return search (id, active_scene, prop, count, inv, rec) if active_scene != null else null;
	# Otherwise.
	else:
		# Contains "DontDestroyOnLoad" node reference.
		var container = obj.get_viewport ().get_node_or_null ("DontDestroyOnLoad") if not Engine.editor_hint else obj.get_viewport ();
		# Returns an/some indestructible node(s).
		return search (id, container, prop, count, inv, rec) if container != null else null;

"""
	@Description: Gets all nodes inside of named node \"DontDestroyOnLoad\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_all_indestructible_nodes (object: Node) -> Array:
	# Contains the container of don't destroy nodes.
	var dont_destroyer = object.get_viewport ().get_node_or_null ("DontDestroyOnLoad");
	# If the "DontDestroyOnLoad" container is not defined.
	return dont_destroyer.get_children () if dont_destroyer != null else Array ([]);

"""
	@Description: Gets the node where the class name is \"SaveLoadFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_data_manager (object: Node): return get_indestructible ("SaveLoadFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"AudioControllerFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_audio_manager (object: Node): return get_indestructible ("AudioControllerFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"ScenesFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_scenes_manager (object: Node): return get_indestructible ("ScenesFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"LanguagesFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_languages_manager (object: Node): return get_indestructible ("LanguagesFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"SettingsFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_settings_manager (object: Node): return get_indestructible ("SettingsFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"ControllersSensorFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_controllers_manager (object: Node): return get_indestructible ("ControllersSensorFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"CursorFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_cursor_manager (object: Node): return get_indestructible ("CursorFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"VideoRecorderFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_video_recorder (object: Node): return get_indestructible ("VideoRecorderFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"AudioRecorderFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_audio_recorder (object: Node): return get_indestructible ("AudioRecorderFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Gets the node where the class name is \"MultiplayerFx\".
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_multiplayer_manager (object: Node): return get_indestructible ("MultiplayerFx", object, NodeProperty.TYPE, 1);

"""
	@Description: Determinates whether an index is out of range from an array or dictionary.
	@Parameters:
		int index_value: Contains the value of an index.
		int size: Contains the size of the target array or dictionary.
"""
static func index_validation (index_value: int, size: int) -> bool: return index_value >= (size * -1) and index_value < size;

"""
	@Description: Determinates whether an index is out of range from an array or dictionary.
	@Parameters:
		int index_value: Contains the value of an index.
		int size: Contains the size of the target array or dictionary.
		String message: Contains the message that will be printed on the editor console when the given index value is out of range of the given array or dictionary.
		int type: Contains the type of the given message. The available values are:
			-> MegaAssets.Message.NORMAL or 0: Simple message.
			-> MegaAssets.Message.WARNING or 1: Warning message.
			-> MegaAssets.Message.ERROR or 2: Error message.
"""
static func index_validation_msg (index_value: int, size: int, message: String = '', type: int = Message.NORMAL) -> bool:
	# If it's a correct index.
	if !index_validation (index_value, size):
		# If a message is defined.
		if not message.lstrip (' ').rstrip (' ').empty (): _output (message, type); return false;
	# Otherwise.
	else: return true;

"""
	@Description: Instanciates a node from a file path.
	@Parameters:
		Dictionary data: Contains all data about the future instance of the target prefab. This parameter accepts the following keys:
			-> String path: Contains the path to the future prefab to loaded.
			-> NodePath | String parent: Where the given prefab will be imported ?
			-> Vector3 position: Contains the position of the prefab to loaded.
			-> Vector3 rotation: Contains the rotation of the prefab to loaded.
			-> Vector3 scale: Contains the scaling of the prefab to loaded.
			-> float live = -1: Contains the delay before destroying the prefab.
			-> bool visible = true: Your prefab will visible or not.
			-> bool duplicate = false: Duplicate prefab when it already loaded previously.
			-> String name: Do you want to change the name of the future prefab ?
			-> String | PoolStringArray groups: Do you want to add some group(s) to the future prefab ?
			-> int zindex = -1: Do you want to change the prefab hierarchy position after loading ?
			-> bool background = true: Do you want to load the prefab on background process ?
			-> bool open = true: Do you want to fix the future prefab into the scene tree.
			-> bool global = false: Do you want to fix the prefab into the scene global position, rotation and scale after loading ?
			-> Dictionary callback: Contains a callback method that will be executed when the prefab is loading to get in real time, the loading
				progress. This dictionary support the following keys:
				-> String method: Contains a callback name.
				-> String | NodePath source: Where found the given callback ?
				Note that the method to be executed must have four (04) parameters namely:
				-> String id: Will contain the name of the file or the object.
				-> int progress: Will contain the current progress of the object being loaded.
				-> Variant reference: Will contain the reference of the object when it has been successfully loaded. By default, you will have a zero value.
				-> Variant error: Will contain the triggered error while loading the object. This parameter will return you a dictionary containing the keys:
					"message", "code" and "type" or null if no error occurred while loading the object.
		Node object: Which knot will be considered to make the differents operations ?
		float delay: What is the time before this action ?
"""
static func instanciate (data: Dictionary, object: Node, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
	# Getting the given callback.
	data.callback = data.callback if data.has ("callback") && data.callback is Dictionary else Dictionary ({});
	# Getting the path value.
	data.path = data.path.lstrip (' ').rstrip (' ') if data.has ("path") and data.path is String else '';
	# If the prefab path is defined.
	if not data.path.empty ():
		# Check prefab extension.
		if data.path.ends_with (".tscn") or data.path.ends_with (".scn") or data.path.ends_with (".tres") or data.path.ends_with (".res"):
			# Check path validity.
			if ResourceLoader.exists (data.path):
				# Getting the given new name of the future prefab.
				data.name = data.name if data.has ("name") and data.name is String else '';
				# Contains an instance of the loaded prefab.
				var prefab = null; var fname: String = data.path.get_file (); var step: int = 0; var progress: int = 0;
				# Getting the future parent of the given prefab.
				data.parent = (data.parent if data.parent is String || data.parent is NodePath else object.get_path ()) if data.has ("parent") else object.get_path ();
				# Get the real parent node.
				var parent = object.get_node_or_null (data.parent);
				# If the parent is a Node.
				if parent is Node:
					# Get the parent node prefix.
					var parent_prefix: String = get_object_prefix (parent);
					# Check whether the prefab to loaded is already exists on the given parent node.
					var child = parent.get_node_or_null (fname.split ('.') [0].lstrip (' ').rstrip (' '));
					# Re-get the parent child whether the last reference is null.
					child = parent.get_node_or_null (data.name if !data.name.empty () else '') if child == null else child;
					# The prefab to loaded don't exists.
					if child == null:
						# The prefab won't be loaded on background.
						if not (data.background if data.has ("background") and data.background is bool else true):
							# Check "callback" key presence and start loading prefab.
							_callback_manager (data.callback, Array ([fname, 0, null, null]), false, object); prefab = load (data.path);
							# Check whether the given path has been cached before.
							if prefab != null:
								# Get prefab reference and update the loading progress.
								prefab = prefab.instance (); progress = 100;
							# Otherwise.
							else: _callback_manager (data.callback, Array ([fname, 0, null, Dictionary ({
								"message": ('{' + fname + "} is already loading in other process."), "code": ERR_FILE_ALREADY_IN_USE, "type": Message.ERROR
							})]), true, object);
						# The prefab will be loaded in background.
						else:
							# Update the prefab.
							prefab = ResourceLoader.load_interactive (data.path);
							# The path is not correct or the target access is denied.
							if prefab == null: _callback_manager (data.callback, Array ([fname, 0, null, Dictionary ({
								"message": ('{' + fname + "} is already loading in other process."), "code": ERR_FILE_ALREADY_IN_USE, "type": Message.ERROR
							})]), true, object);
							# Otherwise.
							else:
								# Check the loading step for any error.
								while step == OK:
									# Waiting for smooth.
									if !Engine.editor_hint: yield (object.get_tree (), "idle_frame");
									# Update the loading progress.
									progress = ((prefab.get_stage () * 100) / prefab.get_stage_count ());
									# Call the given callback to update prefab progress and polls the next stage.
									_callback_manager (data.callback, Array ([fname, progress, null, null]), false, object); step = prefab.poll ();
								# There are no errors.
								if step == ERR_FILE_EOF:
									# Get prefab reference and update the loading progress.
									prefab = prefab.get_resource ().instance (); progress = 100;
								# Some errors have been thrown.
								else: _callback_manager (data.callback, Array ([fname, progress, null, Dictionary ({
									"message": "An error has been thrown on loading prefab.", "code": FAILED, "type": Message.ERROR
								})]), true, object);
					# Otherwise.
					else:
						# Get duplicate key value.
						data.duplicate = data.duplicate if data.has ("duplicate") and data.duplicate is bool else false;
						# Duplicate option is not enabled.
						if not data.duplicate:
							# Normal message.
							_output (('{' + child.name + "} node is already loaded on {" + parent_prefix + "}."), Message.NORMAL); return;
						# Otherwise.
						else:
							# Change a certains configurations.
							prefab = child.duplicate (); fname = data.name if not data.name.empty () else prefab.name; progress = -1;
					# Check pref value.
					if prefab != null:
						# Do you want to change the global coordinates ?
						data.global = data.global if data.has ("global") and data.global is bool else false;
						# Change the prefab name.
						prefab.name = data.name if not data.name.empty () else prefab.name;
						# Getting user group(s).
						data.groups = data.groups if data.has ("groups") else PoolStringArray ([]);
						# Converting the given group into an Array.
						data.groups = Array ([data.group]) if not is_array (data.groups) else Array (data.groups);
						# Converting the result into a PoolStringArray.
						data.groups = PoolStringArray (data.groups);
						# Add available group(s) on the prefab.
						for group in data.groups: if not prefab.is_in_group (group): prefab.add_to_group (group);
						# Do you want to Import the loaded prefab into the scene tree ?
						if (data.open if data.has ("open") and data.open is bool else true):
							# Getting zindex value.
							data.zindex = data.zindex if data.has ("zindex") and is_number (data.zindex) else -1;
							# If the visibility is defined.
							if data.has ("visible") && data.visible is bool: prefab.visible = data.visible; parent.add_child (prefab);
							# Applying zindex effect.
							if prefab is Node: move_node (prefab.get_path (), parent.get_path (), data.zindex, object, -1.0);
							# If the position is defined.
							if data.has ("position"):
								# For a Spatial object.
								if prefab is Spatial:
									data.position = any_to_vector3 (data.position);
									prefab.transform.origin = data.position if !data.global && data.position != null else prefab.transform.origin;
									prefab.global_transform.origin = data.position if data.global && data.position != null else prefab.global_transform.origin;
								# For a Node2D object.
								elif prefab is Node2D:
									data.position = any_to_vector2 (data.position);
									prefab.position = data.position if !data.global && data.position != null else prefab.position;
									prefab.global_position = data.position if data.global && data.position != null else prefab.global_position;
								# For a Control object.
								elif prefab is Control:
									data.position = any_to_vector2 (data.position);
									prefab.rect_position = data.position if !data.global && data.position != null else prefab.rect_position;
									prefab.rect_global_position = data.position if data.global && data.position != null else prefab.rect_global_position;
							# If the rotation is defined.
							if data.has ("rotation"):
								# For a Spatial object.
								if prefab is Spatial:
									data.rotation = any_to_vector3 (data.rotation);
									prefab.rotation_degrees = data.rotation if data.rotation != null else prefab.rotation_degrees;
								# For a Node2D object.
								elif prefab is Node2D and is_number (data.rotation): prefab.rotation_degrees = float (data.rotation);
								# For a Control object.
								elif prefab is Control and is_number (data.rotation): prefab.rect_rotation = float (data.rotation);
							# If the scale is defined.
							if data.has ("scale"):
								# For a Spatial object.
								if prefab is Spatial:
									data.scale = any_to_vector3 (data.scale); prefab.scale = data.scale if data.scale != null else prefab.scale;
								# For a Node2D object.
								elif prefab is Node2D:
									data.scale = any_to_vector2 (data.scale); prefab.scale = data.scale if !data.global && data.scale != null else prefab.scale;
									prefab.global_scale = data.scale if data.global && data.scale != null else prefab.global_scale;
								# For a Control object.
								elif prefab is Control:
									data.scale = any_to_vector2 (data.scale); prefab.rect_scale = data.scale if data.scale != null else prefab.rect_scale;
							# Call the given callback to pass the loaded prefab.
							_callback_manager (data.callback, Array ([fname, progress, prefab, null]), false, object);
						# Check the prefab live.
						if !Engine.editor_hint && data.has ("live") && is_number (data.live) && float (data.live) >= 0.0:
							# Waiting for prefab live and check the prefab definition after.
							yield (object.get_tree ().create_timer (float (data.live)), "timeout"); if is_instance_valid (prefab): prefab.queue_free ();
					# Otherwise.
					else: _callback_manager (data.callback, Array ([fname, progress, prefab, null]), false, object);
				# Error message.
				else: _output ("The given parent node is not defined.", Message.ERROR);
			# Error message.
			else: _output ("The prefab to loaded doesn't exists.", Message.ERROR);
		# Error message.
		else: _output ("This method can only support (.tscn), (.scn), (.tres) and (.res) files extension.", Message.ERROR);
	# Error message.
	else: _output ("The prefab path is not defined.", Message.ERROR);

"""
	@Description: Instanciates severals nodes from their file path.
	@Parameters:
		Array data: Contains a array of dictionary data about each prefab. The dictionary accepts the following keys:
			-> String path: Contains the path to the future prefab to loaded.
			-> Node parent: Where the given prefab will be imported ?
			-> Vector3 position: Contains the position of the prefab to loaded.
			-> Vector3 rotation: Contains the rotation of the prefab to loaded.
			-> Vector3 scale: Contains the scaling of the prefab to loaded.
			-> float live = -1: Contains the delay before destroying of the prefab.
			-> int count = 1: How many prefab will be imported ? If the count value is less than 0, you will get an infinite prefab importation.
			-> float interval = 0.0: What is the delay before each instance ?
			-> bool visible = true: Your prefab will visible or not.
			-> bool duplicate = false: Duplicate prefab when it already loaded previously.
			-> String name: Do you want to change the name of the future prefab ?
			-> String | PoolStringArray groups: Do you want to add some group(s) to the future prefab ?
			-> int zindex = -1: Do you want to change the prefab hierarchy position after loading ?
			-> bool background = true: Do you want to load the prefab on background process ?
			-> bool open = true: Do you want to fix the future prefab into the scene tree.
			-> bool global = false: Do you want to fix the prefab into the scene global position, rotation and scale after loading ?
			-> Dictionary callback: Contains a callback method that will be executed when the prefab is loading to get in real time, the loading
				progress. This dictionary support the following keys:
				-> String method: Contains a callback name.
				-> String | NodePath source: Where found the given callback ?
				Note that the method to be executed must have four (04) parameters namely:
				-> String id: Will contain the name of the file or the object.
				-> int progress: Will contain the current progress of the object being loaded.
				-> Variant reference: Will contain the reference of the object when it has been successfully loaded. By default, you will have a zero value.
				-> Variant error: Will contain the triggered error while loading the object. This parameter will return you a dictionary containing the keys:
					"message", "code" and "type" or null if no error occurred while loading the object.
		Node object: Which knot will be considered to make the differents operations ?
		bool async: Do us asynchronously load the different(s) object(s) given ?
		int direction: which direction should be used for instancing prefabs ? The possibles values are:
			-> MegaAssets.Orientation.NORMAL or 0: Normal prefabs importation.
			-> MegaAssets.Orientation.REVERSED or 1: Reversed prefabs importation.
			-> MegaAssets.Orientation.RANDOM or 2: Randomize prefabs importation.
			-> MegaAssets.Orientation.ALTERNATE or 3: Alternate prefabs importation.
		int repeat: How many prefabs array will have to be runned ? If this value is less than 0, the array will be runned infinity. Nothing would
			happen over no repeat.
		float delay: What is the timeout before this action ?
"""
static func instanciates (data: Array, object: Node, async: bool = false, direction: int = Orientation.NORMAL, repeat: int = 1, delay: float = 0.0) -> void:
	# If the array size is not null.
	if not data.empty ():
		# The game is running.
		if !Engine.editor_hint:
			# If the game is not initialised.
			if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
			# Otherwise.
			elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Contains some usefull value for managing directions modes.
		var start: int = 0; var end: int = 0; var step: int = 1; var indexer: int = 0;
		# For normal, reverse and alternate mode.
		if direction == Orientation.NORMAL || direction == Orientation.REVERSED || direction == Orientation.ALTERNATE:
			# Check mode to adapte the start and end position.
			start = 0 if direction == Orientation.NORMAL || direction == Orientation.ALTERNATE else (data.size () - 1);
			end = data.size () if direction == Orientation.NORMAL || direction == Orientation.ALTERNATE else -1;
			step = 1 if direction == Orientation.NORMAL || direction == Orientation.ALTERNATE else -1;
		# Run the array with repeat value.
		while repeat != 0:
			# The indexer value is equal to the repeat parameter value.
			if indexer == repeat: break;
			# For random mode.
			if direction == Orientation.RANDOM:
				# Make a random position.
				randomize (); start = (randi () % data.size ()); end = (start + 1);
			# Instanciating several prefabs.
			for p in range (start, end, step):
				# If the prefab data is a dictionary.
				if data [p] is Dictionary:
					# Getting the object count instance.
					data [p].count = data [p].count if data [p].has ("count") else 1; data [p].count = int (data [p].count);
					# If the prefab count is greather than 0.
					if data [p].count > 0:
						# Instanciate the given prefab at count variable.
						for n in range (0, data [p].count):
							# While n value is less than or equal (count - 1).
							if data [p].count == 1 or n <= (data [p].count - 1) && data [p].count > 1:
								# If user put an interval for each prefab importation.
								if !Engine.editor_hint && data [p].has ("interval") && is_number (data [p].interval) && float (data [p].interval) > 0.0:
									# Waiting for user interval.
									yield (object.get_tree ().create_timer (float (data [p].interval)), "timeout");
								# Check async value.
								if not async and data [p].count == 1: yield (instanciate (data [p], object, -1.0), "completed");
								# Otherwise.
								else: instanciate (data [p], object, -1.0);
							# Get out of the for loop.
							else: break;
					# The prefab count is less than 0.
					elif data [p].count < 0:
						# Infinite importation.
						while data [p].count < 0:
							# Getting object inportation interval.
							data [p].interval = data [p].interval if data [p].has ("interval") && is_number (data [p].interval) else 0.0;
							data [p].interval = 0.001 if float (data [p].interval) <= 0.0 else float (data [p].interval);
							# If user put an interval for each prefab importation.
							if !Engine.editor_hint: yield (object.get_tree ().create_timer (data [p].interval), "timeout");
							# Infinite instanciation.
							instanciate (data [p], object, -1.0);
			# For alternate reverse mode.
			if direction == Orientation.ALTERNATE:
				# Call the same method in resverse mode and get out of the for loop.
				instanciates (data, object, async, Orientation.REVERSED, 1, -1.0); break;
			# Update indexer value.
			indexer += 1 if repeat > 0 else 0;
	# Warning message.
	else: _output ("The data size mustn't be empty.", Message.WARNING);

"""
	@Description: Determinates whether a character is a number.
	@Parameters:
		String character: Contains a character. The size of this parameter must be equal to 1.
"""
static func is_a_number (character: String) -> bool:
	# If the string count is great than 1.
	if character.length () == 1: return is_range (ord (character), 48, 57);
	# Otherwise.
	else:
		# Error message.
		if character.length () > 1: _output ("The character count must be equal to 1.", Message.ERROR); return false;

"""
	@Description: Determinates whether a string is full numbers.
	@Parameters:
		String string: Contains a list of characters.
"""
static func is_full_numbers (string: String) -> bool:
	# Remove all left and right spaces and search whether all characters are full numbers.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	for chr in string: if !is_a_number (chr): return false; return true if not string.empty () else false;

"""
	@Description: Determinates whether a character is a letter.
	@Parameters:
		String character: Contains a character. The size of this parameter must be equal to 1.
"""
static func is_a_letter (character: String) -> bool: return not is_a_number (character);

"""
	@Description: Determinates whether a string is full letters.
	@Parameters:
		String string: Contains a list of characters.
"""
static func is_full_letters (string: String) -> bool:
	# Remove all left and right spaces and search whether all characters are full letters.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	for chr in string: if !is_a_letter (chr): return false; return true if not string.empty () else false;

"""
	@Description: Determinates whether a character is upper case.
	@Parameters:
		String character: Contains a character. The size of this parameter must be equal to 1.
"""
static func is_upper_case (character: String) -> bool:
	# If the string count is great than 1.
	if character.length () == 1: return not ord (character.to_upper ()) < ord (character);
	# Otherwise.
	else:
		# Error message.
		if character.length () > 1: _output ("The character count must be equal to 1.", Message.ERROR); return false;

"""
	@Description: Determinates whether a string is full upper case.
	@Parameters:
		String string: Contains a list of characters.
"""
static func is_full_upper_case (string: String) -> bool:
	# Remove all left and right spaces and search whether all characters are full letters.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	for chr in string: if !is_upper_case (chr): return false; return true if not string.empty () else false;

"""
	@Description: Determinates whether a character is lower case.
	@Parameters:
		String character: Contains a character. The size of this parameter must be equal to 1.
"""
static func is_lower_case (character: String) -> bool: return not is_upper_case (character);

"""
	@Description: Determinates whether a string is full lower case.
	@Parameters:
		String string: Contains a list of characters.
"""
static func is_full_lower_case (string: String) -> bool:
	# Remove all left and right spaces and search whether all characters are full letters.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	for chr in string: if !is_lower_case (chr): return false; return true if not string.empty () else false;

"""
	@Description: Finds all numbers from a string.
	@Parameters:
		String string: Contains a list of characters.
"""
static func get_numbers_from (string: String):
	# Remove all left and right spaces.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	# If the given string is empty or is a simple space.
	if string.empty (): return null;
	# Otherwise.
	else:
		# Search all numbers in the given string.
		var filter: PoolIntArray = PoolIntArray ([]); for chr in string: if is_a_number (chr): filter.append (int (chr));
		# Return the final value.
		if filter.size () <= 0: return null; elif filter.size () == 1: return filter [0]; else: return filter;

"""
	@Description: Finds all letters from a string.
	@Parameters:
		String string: Contains a list of characters.
"""
static func get_letters_from (string: String):
	# Remove all left and right spaces.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	# If the given string is empty or is a simple space.
	if string.empty (): return null;
	# Otherwise.
	else:
		# Search all letters in the given string.
		var filter: PoolStringArray = PoolStringArray ([]); for chr in string: if is_a_letter (chr): filter.append (chr);
		# Return the final value.
		if filter.size () <= 0: return null; elif filter.size () == 1: return filter [0]; else: return filter;

"""
	@Description: Finds all letters from a string and the given case (Upper or Lower).
	@Parameters:
		String string: Contains a list of characters.
		bool is_lower: Defined which both cases will be returned.
"""
static func get_letters_case_from (string: String, is_lower: bool):
	# Remove all left and right spaces.
	string = str_replace (string, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	# If the given string is empty or is a simple space.
	if string.empty (): return null;
	# Otherwise.
	else:
		# Contains all contained numbers in the given string.
		var filter: PoolStringArray = PoolStringArray ([]);
		# Search all numbers in the given string.
		for chr in string:
			# Check the nature of this character.
			if is_a_letter (chr):
				# For upper and lower case characters.
				if !is_lower and is_upper_case (chr): filter.append (chr); elif is_lower and is_lower_case (chr): filter.append (chr);
		# Return the final value.
		if filter.size () <= 0: return null; elif filter.size () == 1: return filter [0]; else: return filter;

"""
	@Description: Returns a hexadecimal symbol from the given integer value. Your value must be in range (10; 15).
	@Parameters:
		int value: Contains the value that will be transformed.
		bool is_lower: Defined which both cases will be returned.
"""
static func get_hex_symbol (value: int, is_lower: bool = false):
	# Searches the corresponding value.
	match value:
		# Check the given value.
		10: return ('A' if !is_lower else 'a'); 11: return ('B' if !is_lower else 'b');
		12: return ('C' if !is_lower else 'c'); 13: return ('D' if !is_lower else 'd');
		14: return ('E' if !is_lower else 'e'); 15: return ('F' if !is_lower else 'f');
		# Return the final value.
		_: return value;

"""
	@Description: Returns the normal value from the given hexadecimal symbol. Your value must be in range (a/A; f/F).
	@Parameters:
		String symbol: Contains the symbol that will be transformed.
"""
static func get_int_from_hex (symbol: String):
	# Searches the corresponding value.
	match symbol.to_lower ():
		# Check the given value
		'a': return 10; 'b': return 11; 'c': return 12; 'd': return 13; 'e': return 14; 'f': return 15; _: return symbol;

"""
	@Description: Converts any type into a bit type. Eg: binary, hex, etc... Pay attention ! the supported types are:
		Integer, Float, String, Vector2, Vector3, Array and Dictionary.
	@Parameters:
		Variant type: What is the value of your type ?
		int bit: What is your bit ?
		bool security: Do you want to put a security on the final value ?
"""
static func any_to_bit (type, bit: int, security: bool = true):
	# Check bit value.
	if bit > 1:
		# For Array type value.
		if type is Array: return _list_to_bit (type, bit, security);
		# For Dictionary type value.
		elif type is Dictionary: return _dic_to_bit (type, bit, security);
		# For basics types values.
		else: return _type_to_bit (type, bit, security);
	# Warning message.
	else: _output ("The value of the bit parameter mustn't be less than 2.", Message.WARNING);

"""
	@Description: Returns a normal value of any type from his coded value. Pay attention ! the supported types are: Integer, Float, String, Vector2,
		Vector3, Array and Dictionary. However, if you want to review your data intact, you must use one of the databases
		following: 2 to 10 or 16, knowing that the data has been previously encoded in one of the recommended bases.
	@Parametters:
		String | Array | Dictionary coded_type: Contains the coded value of a type.
		int bit: What is the bit that have been used to coded the type ?
		bool security: Is the coded type have a security ?
"""
static func any_from_bit (coded_type, bit: int, security: bool = true):
	# Check bit value.
	if bit > 1:
		# For Array type value.
		if coded_type is Array: return _list_from_bit (coded_type, bit, security);
		# For Dictionary type value.
		elif coded_type is Dictionary: return _dic_from_bit (coded_type, bit, security);
		# For basics types values.
		else: return _type_from_bit (coded_type, bit, security);
	# Warning message.
	else: _output ("The value of the bit parameter mustn't be less than 2.", Message.WARNING);

"""
	@Description: Generates a key as a string format.
	@Parameters:
		int max_size: Contains the max value of the key that will be generated.
"""
static func generate_key (max_size: int = 16) -> String:
	# If the key size is not less than 0.
	if max_size > 0:
		# Contains the generated key.
		var generated_key: String = '';
		# Contains all availables characters.
		var characters: PoolStringArray = PoolStringArray ([
			'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'l', 'o', 'p', 'q', 'r', 's', 't',
			'u', 'v', 'w', 'x', 'y', 'z', '!', '@', '#', '%', '&', '^', '*', '_', '+', '=', '|', '<', ']', '`',
			'²', 'ô', 'ŵ', '/', '>', '(', 'é', '\'', 'ê', 'ŝ', 'ĉ', '.', '$', ')', 'è', '"', 'ŷ', 'ĝ', ';', '?',
			'~', '{', 'à', '\\', 'û', 'ĥ', ',', ':', '[', '}', '-', 'â', 'î', 'ĵ', 'ù', 'A', 'B', 'C', 'D', 'E',
			'F', 'G', 'H', 'I', 'J', 'K', 'M', 'N', 'L', 'O', 'P', 'A', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
			'Z', 'Ô', 'Ŵ', 'Ê', 'Ŝ', 'Ĉ', 'Ŷ', 'Ĝ', 'Û', 'Ĥ', 'Â', 'Î', 'Ĵ', '8', '9', 'é'.to_upper (),
			'è'.to_upper (), 'à'.to_upper (), 'ù'.to_upper (), '0', '1', '2', '3', '4', '5', '6', '7'
		]);
		# Generating each character of the key.
		for _p in range (0, max_size):
			# Make a randomize.
			randomize (); var chr_gen: String = characters  [randi () % characters.size ()];
			# For invert generation.
			if randi () % 2 == 0: generated_key = generated_key.insert (0, chr_gen);
			# For normal generation.
			else: generated_key = generated_key.insert ((len (generated_key) - 1), chr_gen);
		# Return the final value.
		return generated_key;
	# Return an empty value.
	else: return "Null";

"""
	@Description: Generates some keys as string format.
	@Parameters:
		int key_count: Contains the total key count that will be generated.
		int max_size: Contains the max value of each key.
"""
static func generate_keys (key_count: int, max_size: int = 16) -> PoolStringArray:
	# Contains all generated keys.
	var keys: PoolStringArray = PoolStringArray ([]); var key: String = '';
	# If key count is equal to zero.
	if key_count > 0:
		# Generating keys.
		for _v in range (0, key_count):
			# If the keys list has a key.
			if keys.size () == 0: key = generate_key (max_size);
			# If the generated key is equal the last generated key in the keys list.
			else: while key == keys [(keys.size () - 1)]: key = generate_key (max_size); keys.append (key);
		# Return the final value.
		return keys;
	# Return an empty value.
	else: return keys;

"""
	@Description: Transforms a bytes list into text.
	@Parameters:
		PoolByteArray bytes: Contains all bytes of transformed characters.
"""
static func bytes_to_text (bytes: PoolByteArray) -> String:
	# If the bytes array is not less than 0.
	if bytes.size () > 0:
		# Contains the normal text of the given bytes array.
		var text: String = ''; for byte in bytes: text += char (byte); return text;
	# Otherwise.
	else: _output ("The bytes array size mustn't be empty.", Message.WARNING); return "Null";

"""
	@Description: Generates a screenshot from the active camera.
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
		Dictionary data: Contains the different configurations to be made on the capture, once generated. This dictionary supports keys following:
			Vector2 size = Vector2 (-1, -1): Contains the screenshot resolution.
			int quality = Image.INTERPOLATE_CUBIC: Contains the image resolution quality. he supported constants are already defined on Godot image class.
			int skrink = 0: Control the image shrinkage.
			int comp_mode = MegaAssets.ImageCompression.ETC: What mode of compression do you want to adopt to compress the image ? The possibles values ​​are:
				-> MegaAssets.ImageCompression.NONE or 0: No compression will be applyed.
				-> MegaAssets.ImageCompression.ETC or 1: Compression with ETC method.
				-> MegaAssets.ImageCompression.ETC2 or 2: Compression with ETC2 method.
				-> MegaAssets.ImageCompression.S3TC or 3: Compression with S3TC method.
			int comp_source = Image.COMPRESS_SOURCE_GENERIC: From what compression source the image will compress ? See Godot Image class constants.
				Use this key only if the image needs to be compressed.
			int format = MegaAssets.ImageFormat.RGBAH: Contains the format of the image. Use this key only if the image needs to be compressed.
				The possibles values are:
				-> MegaAssets.ImageFormat.RH or 0: Converts image to RH format.
				-> MegaAssets.ImageFormat.RF or 1: Converts image to RF format.
				-> MegaAssets.ImageFormat.RGH or 2: Converts image to RGH format.
				-> MegaAssets.ImageFormat.RGF or 3: Converts image to RGF format.
				-> MegaAssets.ImageFormat.RGBH or 4: Converts image to RGBH format.
				-> MegaAssets.ImageFormat.RGBF or 5: Converts image to RGBF format.
				-> MegaAssets.ImageFormat.RGBAH or 6: Converts image to RGBAH format.
				-> MegaAssets.ImageFormat.RGBAF or 7: Converts image to RGBAF format.
				-> MegaAssets.ImageFormat.RGBA4444 or 8: Converts image to RGBA4444 format.
				-> MegaAssets.ImageFormat.RGBA5551 or 9: Converts image to RGBA5551 format.
				-> MegaAssets.ImageFormat.RGBA9995 or 10: Converts image to RGBA9995 format.
			float ratio = 100.0: What rate of compression do you want to apply to the image ? Use this key only if the image must be compressed.
"""
static func get_screen_shot (object: Node, data: Dictionary = Dictionary ({})) -> ImageTexture:
	# Getting the current game viewport.
	var app = object.get_viewport ();
	# Checks the viewport value.
	if app is Viewport:
		# Getting the generated image from the viewport.
		var img: Image = app.get_texture ().get_data (); img.flip_y ();
		# Getting the passed screenshot size.
		data.size = data.size if data.has ("size") and data.size is Vector2 else Vector2 (-1, -1);
		# Getting the passed screenshot quality.
		data.quality = int (data.quality) if data.has ("quality") && is_number (data.quality) else Image.INTERPOLATE_CUBIC;
		# Resizes the given image with the available size.
		data.size = Vector2 ((app.size.x if data.size.x < 0 else data.size.x), (app.size.y if data.size.y < 0 else data.size.y));
		# Resizing the generated screenshot.
		img.resize (int (data.size.x), int (data.size.y), (0 if data.quality < 0 else (4 if data.quality > 4 else data.quality)));
		# Getting the passed screenshot skrink count.
		data.skrink = int (data.skrink) if data.has ("skrink") && is_number (data.skrink) else 0;
		# Apply the skrink count.
		for _f in range (data.skrink if data.skrink >= 0 else 0): img.shrink_x2 (); var screen_shot: ImageTexture = ImageTexture.new ();
		# Getting the passed screenshot compress mode.
		data.comp_mode = int (data.comp_mode) if data.has ("comp_mode") && is_number (data.comp_mode) else Image.COMPRESS_ETC;
		# Filters the given screenshot compression mode.
		var filter_compress_mode: int = get_real_image_compression (data.comp_mode);
		# Checks compression mode.
		if filter_compress_mode >= 0:
			# Converting the generated screenshot texture to the passed image format.
			img.convert (get_real_image_format (int (data.format) if data.has ("format") && is_number (data.format) else Image.FORMAT_RGBAH));
			# Getting the passed screenshot compress source.
			data.comp_source = int (data.comp_source) if data.has ("comp_source") && is_number (data.comp_source) else Image.COMPRESS_SOURCE_GENERIC;
			# Getting the passed screenshot compress ratio.
			data.ratio = float (data.ratio) if data.has ("ratio") && is_number (data.ratio) && float (data.ratio) >= 0.0 else 100.0;
			# Compress the generated screenshot image.
			if img.compress (filter_compress_mode, (0 if data.comp_source < 0 else (2 if data.comp_source > 2 else data.comp_source)), data.ratio) == OK:
				# Creating a texture with the given screenshot.
				screen_shot.create_from_image (img);
			# An error has been thrown on screenshot compression.
			else: _output ("Failed to compress the generated screenshot texture.", Message.WARNING);
		# Otherwise.
		else: screen_shot.create_from_image (img); return screen_shot;
	# Otherwise.
	else: return ImageTexture.new ();

"""
	@Description: Creates a screenshot from the active camera.
	@Parameters:
		String path: Where want you put your screen shot ? The required format of your image must be (.png).
		Node object: Which knot will be considered to make the differents operations ?
		Dictionary data: Contains the different configurations to be made on the capture, once generated. For more information, consult the documentation
			about "get_screen_shot ()" method.
		float delay: What is the timeout before creating of the screen shot ?
"""
static func create_screen_shot (path: String, object: Node, data: Dictionary = Dictionary ({}), delay: float = 0.0) -> void:
	# If the path value is not empty.
	if path != null and not path.empty ():
		# Checks the given screen shot format.
		if path.ends_with (".png"):
			# The game is running.
			if !Engine.editor_hint:
				# If the game is not initialised.
				if delay <= 0.0 && not is_game_initialised ():
					# Waiting for game initialization.
					yield (object.get_tree (), "idle_frame"); yield (object.get_tree (), "idle_frame");
				# Otherwise.
				elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
			# Getting the current viewport screenshot image.
			var screen_shot: Image = (get_screen_shot (object, data) as Texture).get_data ();
			# Creating the screenshot on the disk.
			if screen_shot.save_png (path.get_file ()) != OK: _output ("Failed to create the game screenshot !", Message.WARNING);
		# Error message.
		else: _output ("The required format of a screenshot is (.png).", Message.ERROR);
	# Warning message.
	else: _output ("The path shouldn't be empty.", Message.WARNING);

"""
	@Description: Transforms a hexadecimal value into raw value from a string value.
	@Parameters:
		String string: Contains a hex value as string format.
"""
static func hex_to_raw (string: String) -> String:
	# Initialize raw arrays.
	var out: PoolByteArray = PoolByteArray (); var hs: String = "0x00";
	# Converting the given string to raw.
	for i in range (0, string.length (), 2):
		hs [2] = string [i]; hs [3] = string [(i + 1)]; out.append (hs.hex_to_int () & 0xff);
	# Return the final result.
	return bytes_to_text (out);

"""
	@Description: Transforms a raw value into a hexadecimal value from a string value.
	@Parameters:
		String string: Contains a raw value as string format.
"""
static func raw_to_hex (string: String) -> String:
	# Contains the string value as bytes format.
	var bytes: PoolByteArray = string.to_ascii (); var hex: String = '';
	# Return the final value.
	for i in range (bytes.size ()): hex += ("%02x" % (bytes [i] & 0xff)); return hex;

"""
	@Description: Returns a rotl64 of two integers.
	@Parameters:
		int n: Contains an integer value.
		int r: Contains an integer value.
"""
static func rotl64 (n: int, r: int) -> int:
	# Preserves the sign bit so we need to mask to perform a logical shift on the second part.
	r = (r & 0x3f); if (r == 0): return n; return (n << r) | ((n >> (64 - r)) & _ROTL64_MASK [(64 - r)]);

"""
	@Description: Returns a rotr32 of two integers.
	@Parameters:
		int n: Contains an integer value.
		int r: Contains an integer value.
"""
static func rotr32 (n: int, r: int) -> int:
	# Return the final value.
	n = (n & _B32); r = (r & 0x1f); if (r == 0): return n; return ((n >> r) & _B32) | ((n << (32 - r)) & _B32);

"""
	@Description: Encrypts an input buffer with a key. This method support severals encryption methods.
	@Parameters:
		Variant input: A buffer that will be encrypted.
		String key: Contains the key that will be used to encrypt the passed input (16/32 bytes).
		int method: which method that will be used to encrypt the passes input ? The possibles values are:
			-> MegaAssets.EncryptionMethod.AES or 0: Data encryption with AES method.
			-> MegaAssets.EncryptionMethod.ARCFOUR or 1: Data encryption with ARCFOUR method.
			-> MegaAssets.EncryptionMethod.CHACHA or 2: Data encryption with CHACHA method.
		int schema: Contains the way that will be used to encrypt the passed input. The possibles values are:
			-> MegaAssets.EncryptionSchema.BASE64 or 0: Data encryption with Base64 schema.
			-> MegaAssets.EncryptionSchema.HEXADECIMAL or 1: Data encryption with Hexadecimal schema.
			-> MegaAssets.EncryptionSchema.RAW or 2: Data encryption with Raw schema.
"""
static func encrypt (input, key: String = '', method: int = EncryptionMethod.CHACHA, schema: int = EncryptionSchema.BASE64) -> String:
	# The key length is out of range.
	if len (key) > 32: _output ("The key size must be 128/256 bits (16/32 bytes).", Message.ERROR);
	# No errors detected.
	else:
		# Correct the passed key.
		if len (key) < 16: while key.length () < 16: key += ' '; elif len (key) > 16 && len (key) < 32: while key.length () < 32: key += ' ';
		# For AES method.
		if method <= EncryptionMethod.AES:
			# For BASE 64 schema.
			if schema <= EncryptionSchema.BASE64: return Marshalls.raw_to_base64 (encrypt (str (input), key, method, 2).to_ascii ());
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return raw_to_hex (encrypt (str (input), key, method, 2));
			# For RAW schema.
			else:
				# Convert the input into a PoolByteArray and calculate the padding.
				input = str (input).to_ascii (); var padding: int = (16 - (input.size () % 16)); for _k in range (padding): input.append (padding);
				# Correct the passed key value.
				var keys: Array = _key_schedule (key.to_ascii ()); var encrypted_value: PoolByteArray = PoolByteArray ([]);
				# Encrypt the given input with AES encryption method.
				for p in range (int (len (input) / 16.0)):
					# Decrypting the current block.
					var block: PoolByteArray = input.subarray ((p * 16), (p * 16 + 15));
					block = _encrypt_block (block, keys); encrypted_value.append_array (block);
				# Return the final value as string format.
				return bytes_to_text (encrypted_value);
		# For ARCFOUR method.
		elif method == EncryptionMethod.ARCFOUR:
			# For BASE 64 schema.
			if schema <= EncryptionSchema.BASE64: return Marshalls.raw_to_base64 (encrypt (str (input), key, method, 2).to_ascii ());
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return raw_to_hex (encrypt (str (input), key, method, 5));
			# For RAW schema.
			else:
				# Convert the input and key into a PoolByteArray.
				var data: Array = [str (input).to_ascii (), key.to_ascii ()];
				# Input and key length.
				var il: int = data [0].size (); var kl: int = data [1].size (); var op: PoolByteArray = PoolByteArray ();
				# Resizing the output.
				op.resize (il); var i: int = 0; var j: int = 0; var k: int = 0; var t: int = 0;
				# Key schedule.
				var s: PoolByteArray = PoolByteArray (); s.resize (256);
				for c in range (256):
					i = c; s [i] = i;
				for q in range (256):
					i = q; j = (j + s [i] + data [1] [(i % kl)]) & 0xff; t = s [i]; s [i] = s [j]; s [j] = t;
				# De/encrypt input => output. Optionally drop some initial keystream bytes.
				i = 0; j = 0; k = 0;
				for p in range (il):
					i = (i + 1) & 0xff; j = (j + s [i]) & 0xff; t = s [i]; s [i] = s [j]; s [j] = t;
					if (p >= 0):
						op [k] = data [0] [k] ^ s [(s [i] + s [j]) & 0xff]; k += 1;
				# Return the final value.
				return bytes_to_text (op);
		# For CHACHA method.
		else:
			# For BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return Marshalls.raw_to_base64 (encrypt (str (input), key, method, 2).to_ascii ());
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return raw_to_hex (encrypt (str (input), key, method, 5));
			# For RAW schema.
			else:
				# Convert the input into a PoolByteArray.
				input = str (input).to_ascii (); var ky: PoolByteArray = PoolByteArray ([]);
				var op: PoolByteArray = PoolByteArray ([]); op.resize (len (input)); var i: int = 0;
				var chacha: _ChaChaBlockCipher = _ChaChaBlockCipher.new (); var ki: int = 64; var ct: int = 1;
				while (i < len (input)):
					# Generate new key material for each block.
					if (ki == 64):
						ky = chacha.chacha20_block (key.to_ascii (), "AhjlNp3Mu8ycTfQ$".to_ascii (), ct, 20); ki = 0; ct += 1;
					# Xor key with input to get output.
					op [i] = (input [i] ^ ky [ki]); i += 1; ki += 1;
				# Return the final value.
				return bytes_to_text (op);
	# Return a null value whether there are some errors.
	return "Null";

"""
	@Description: Decrypts an input buffer with a key. This method support severals encryption methods.
	@Parameters:
		Variant input: A buffer that will be decrypted. It would have contained an encrypted value. His length must be a multiple of 16. 
		String key: Contains the key that had been used to encrypt the passed input last time with encrypt function (16/32 bytes).
		int method: which method had been used to encrypt the passed input last time with encrypt function ? The possibles values are:
			-> MegaAssets.EncryptionMethod.AES or 0: Data decryption with AES method.
			-> MegaAssets.EncryptionMethod.ARCFOUR or 1: Data decryption with ARCFOUR method.
			-> MegaAssets.EncryptionMethod.CHACHA or 2: Data decryption with CHACHA method.
		int schema: Contains the way that had been used to encrypt the passed input last time with encrypt function. The possibles values are:
			-> MegaAssets.EncryptionSchema.BASE64 or 0: Data decryption with Base64 schema.
			-> MegaAssets.EncryptionSchema.HEXADECIMAL or 1: Data decryption with HexADECIMAL schema.
			-> MegaAssets.EncryptionSchema.RAW or 2: Data decryption with Raw schema.
"""
static func decrypt (input: String, key: String = '', method: int = EncryptionMethod.CHACHA, schema: int = EncryptionSchema.BASE64):
	# The key length is out of range.
	if len (key) > 32: _output ("The key size must be 128/256 bits (16/32 bytes).", Message.ERROR);
	# No errors detected.
	else:
		# Correct the passed key.
		if len (key) < 16: while key.length () < 16: key += ' '; elif len (key) > 16 && len (key) < 32: while key.length () < 32: key += ' ';
		# For AES method.
		if method <= EncryptionMethod.AES:
			# For BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return decrypt (Marshalls.base64_to_raw (input).get_string_from_ascii (), key, method, 2);
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return decrypt (hex_to_raw (input), key, method, 2);
			# For RAW schema.
			else:
				# Convert the given encrypted value into a PoolByteArray.
				var encrypted_bytes: PoolByteArray = input.to_ascii ();
				# Convert the passed key into a valid PoolByteArray format.
				var keys: Array = _key_schedule (key.to_ascii ()); var decrypted_bytes: PoolByteArray = PoolByteArray ([]);
				# Starting decryption.
				for i in range (int (encrypted_bytes.size () / 16.0)):
					# Initialize cipher and plain blocks bytes.
					var cipher_block: PoolByteArray = encrypted_bytes.subarray ((i * 16), (i * 16 + 15));
					var plain_block: PoolByteArray = _decrypt_block (cipher_block, keys); decrypted_bytes.append_array (plain_block);
				# Calculate encrypted bytes padding since encryption.
				var padding_value: int = decrypted_bytes [(len (decrypted_bytes) - 1)] if (len (decrypted_bytes) - 1) >= 0 else 0;
				# The padding is not valid.
				if padding_value < 1 or padding_value > 16: _output ("Decryption failed: The input length is too big.", Message.WARNING);
				# Otherwise.
				else:
					# Calculate the next padding.
					var padding: PoolByteArray = decrypted_bytes.subarray ((decrypted_bytes.size () - padding_value), (decrypted_bytes.size () - 1));
					# Get padding value and check his validation.
					for i in padding: if i != padding_value: _output ("Decryption failed: inconsistent padding value.", Message.WARNING);
					decrypted_bytes = decrypted_bytes.subarray (0, (decrypted_bytes.size () - (padding_value - 1)));
				# Return the decrypted value as PoolByteArray format.
				return get_variant (bytes_to_text (decrypted_bytes));
		# For CHACHA and ARCFOUR method.
		else:
			# For BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return decrypt (Marshalls.base64_to_raw (input).get_string_from_ascii (), key, method, 2);
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return decrypt (hex_to_raw (input), key, method, 5);
			# For RAW schema.
			else: return get_variant (encrypt (input, key, method, 2));

"""
	@Description: Hashs an input buffer with a key. This method support severals hashing methods.
	@Parameters:
		Variant input: A buffer that will be hashed.
		String key: Contains the key that will be used to hash the passed input (16 bytes).
		int method: which method that will be used to hash the passes input ? The possibles values are:
			-> MegaAssets.HashingMethod.SIP or 0: Data hashing with SIP method.
			-> MegaAssets.HashingMethod.SHA256 or 1: Data hashing with SHA256 method.
			-> MegaAssets.HashingMethod.HASHMAC_SHA256 or 2: Data hashing with HASHMAC method.
			-> MegaAssets.HashingMethod.GODOT_SHA256 or 3: Data hashing with Godot SHA256 method.
			-> MegaAssets.HashingMethod.MD5 or 4: Data hashing with MD5 method.
			-> MegaAssets.HashingMethod.AES or 5: Data hashing with AES method.
			-> MegaAssets.HashingMethod.ARCFOUR or 6: Data hashing with ARCFOUR method.
			-> MegaAssets.HashingMethod.CHACHA or 7: Data hashing with SIP method.
		int schema: Contains the way that will be used to hash the passed input. The possibles values are:
			-> MegaAssets.EncryptionSchema.BASE64 or 0: Data hashing with Base64 schema.
			-> MegaAssets.EncryptionSchema.HEXADECIMAL or 1: Data hashing with Hex schema.
			-> MegaAssets.EncryptionSchema.RAW or 2: Data hashing with Raw schema.
"""
static func hash_var (input, key: String = '', method: int = HashingMethod.SIP, schema: int = EncryptionSchema.BASE64) -> String:
	# The key length is out of range.
	if len (key) > 16: _output ("The key size must be 128 bits (16 bytes).", Message.ERROR);
	# No errors detected.
	else:
		# Transfrom the input into a string format.
		input = str (input); if key.length () < 16: while key.length () < 16: key += ' ';
		# For SIP, SHA256, HASHMACSHA256, AES.
		if method <= HashingMethod.SIP || method == HashingMethod.SHA256 || method == HashingMethod.HASHMAC_SHA256 || method == HashingMethod.AES:
			# For BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return Marshalls.raw_to_base64 (hash_var (input, key, method, 2).to_ascii ());
			# For HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return raw_to_hex (hash_var (input, key, method, 2));
		# For SIP method.
		if method <= HashingMethod.SIP:
			# For RAW schema.
			if schema >= EncryptionSchema.RAW:
				# Convert the input and his key into a PoolByteArray.
				var data: Array = Array ([input.to_ascii (), key.to_ascii ()]);
				# Intialise.
				var v0: int = 0x736f6d65707; var v1: int = 0x646f72616e6; var v2: int = 0x6c7967656e6;
				var v3: int = 0x74656462797; var k0: int = 0; var k1: int = 0;
				for i in range (8):
					k0 = (k0 << 8) | data [1] [(7 - i)]; k1 = (k1 << 8) | data [1] [(7 - i + 8)];
				v3 ^= k1; v2 ^= k0; v1 ^= k1; v0 ^= k0; if (8 == 16): v1 ^= 0xee; var m: int;
				# Main processing.
				var ilen: int = data [0].size (); var imax: int = (ilen - (ilen % 8)); var ilft: int = (ilen & 7);
				for i in range (0, imax, 8):
					m = ((data [0] [i] & 0xff) | ((data [0] [(i + 1)] & 0xff) << 8) | ((data [0] [(i + 2)] & 0xff) << 16) |
					((data [0] [(i + 3)] & 0xff) << 24) | ((data [0] [(i + 4)] & 0xff) << 32) | ((data [0] [(i + 5)] & 0xff) << 40)
					| ((data [0] [(i + 6)] & 0xff) << 48) | ((data [0] [(i + 7)] & 0xff) << 56)); v3 ^= m;
					for _j in range (2):
						v0 += v1; v1 = rotl64 (v1, 13); v1 ^= v0; v0 = rotl64 (v0, 32); v2 += v3;
						v3 = rotl64 (v3, 16); v3 ^= v2; v0 += v3; v3 = rotl64 (v3, 21); v3 ^= v0; v2 += v1;
						v1 = rotl64 (v1, 17); v1 ^= v2; v2 = rotl64 (v2, 32);
					v0 ^= m;
				# Final block processing.
				var b: int = 0; for i in range (ilft, 0, -1): b = (b << 8) | (data [0] [(imax + i - 1)] & 0xff);
				b |= (ilen & 0xff) << 56; v3 ^= b;
				for _j in range (2):
					v0 += v1; v1 = rotl64 (v1, 13); v1 ^= v0; v0 = rotl64 (v0, 32); v2 += v3;
					v3 = rotl64 (v3, 16); v3 ^= v2; v0 += v3; v3 = rotl64 (v3, 21); v3 ^= v0; v2 += v1;
					v1 = rotl64 (v1, 17); v1 ^= v2; v2 = rotl64 (v2, 32);
				v0 ^= b; if (8 == 16): v2 ^= 0xee; else: v2 ^= 0xff;
				# Dround loop.
				for _j in range (4):
					v0 += v1; v1 = rotl64 (v1, 13); v1 ^= v0; v0 = rotl64 (v0, 32); v2 += v3;
					v3 = rotl64 (v3, 16); v3 ^= v2; v0 += v3; v3 = rotl64 (v3, 21); v3 ^= v0; v2 += v1;
					v1 = rotl64 (v1, 17); v1 ^= v2; v2 = rotl64 (v2, 32);
				b = (v0 ^ v1 ^ v2 ^ v3);
				# Create return hash.
				var op: PoolByteArray = PoolByteArray (); for i in _U64_SHIFTS_INV: op.append ((b >> i) & 0xff);
				if (8 == 16):
					v1 ^= 0xdd;
					for _j in range (4):
						v0 += v1; v1 = rotl64 (v1, 13); v1 ^= v0; v0 = rotl64 (v0, 32); v2 += v3;
						v3 = rotl64 (v3, 16); v3 ^= v2; v0 += v3; v3 = rotl64 (v3, 21); v3 ^= v0; v2 += v1;
						v1 = rotl64 (v1, 17); v1 ^= v2; v2 = rotl64 (v2, 32);
					b = (v0 ^ v1 ^ v2 ^ v3); for i in _U64_SHIFTS_INV: op.append ((b >> i) & 0xff);
				# If en error has been detected on hashing.
				if op.size () != 8: _output ("An error has been detected on hasing.", Message.WARNING);
				# Otherwise.
				else: return bytes_to_text (op);
		# For SHA256 method.
		elif method == HashingMethod.SHA256:
			# For RAW schema.
			if schema >= EncryptionSchema.RAW:
				# Convert the given input into a PoolBytesArray.
				input = input.to_ascii ();
				# First 32 bits of the fractional parts of the square roots of the first 8 primes 2..19.
				var h0: int = 0x6a09e667; var h1: int = 0xbb67ae85; var h2: int = 0x3c6ef372; var h3: int = 0xa54ff53a;
				var h4: int = 0x510e527f; var h5: int = 0x9b05688c; var h6: int = 0x1f83d9ab; var h7: int = 0x5be0cd19;
				# Pre-process (pad) the input. Remember PoolByteArray is passed by value so it is safe to modify the input.
				var l: int = (input.size () * 8); input.append (0x80); while ((input.size () + 8) & 0x3f != 0): input.append (0x00);
				# Append L as a 64-bit big-endian integer, making the total post-processed length a multiple of 512 bits.
				for i in _U64_SHIFTS: input.append ((l >> i) & 0xff);
				# If an error has been detected.
				if input.size () & 0x3f != 0: _output ("An error has been detected on hasing.", Message.WARNING);
				# Otherwise.
				else:
					# Process the message in successive 512 bits chunks.
					var w: Array = Array ([
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
					]); var j: int; var s0: int; var s1: int; var t1: int; var t2: int; var ch: int; var mj: int;
					for pos in range (0, input.size (), 64):
						# Create a 64-entry message schedule array w [0..63] of 32-bit words.
						for i in range (0, 16):
							j = pos + (i * 4); w [i] = ((input [j] << 24) | (input [(j + 1)] << 16) |
							(input [(j + 2)] << 8) | input [(j + 3)]); pass;
						# Extend the first 16 words into the remaining 48 words w [16..63] of the message schedule array.
						for i in range (16, 64):
							s0 = rotr32 (w [(i - 15)],  7) ^ rotr32 (w [(i - 15)], 18) ^ (w [(i - 15)] >>  3);
							s1 = rotr32 (w [(i - 2)], 17) ^ rotr32 (w [(i - 2)], 19) ^ (w [(i - 2)] >> 10);
							w [i] = ((w [(i - 16)] + s0 + w [(i - 7)] + s1) & _B32); pass;
						# Initialize working variables to current hash value.
						var a: int = h0; var b: int = h1; var c: int = h2; var d: int = h3; var e: int = h4;
						var f: int = h5; var g: int = h6; var h: int = h7;
						# Compression function main loop.
						for i in range (64):
							s1 = (rotr32 (e, 6) ^ rotr32 (e, 11) ^ rotr32 (e, 25));
							ch = ((e & f) ^ ((~e) & g)); t1 = ((h + s1 + ch + _RK [i] + w [i]) & _B32);
							s0 = (rotr32 (a, 2) ^ rotr32 (a, 13) ^ rotr32 (a, 22));
							mj = ((a & b) ^ (a & c) ^ (b & c)); t2 = (s0 + mj) & _B32; h = g; g = f; f = e;
							e = ((d + t1) & _B32); d = c; c = b; b = a; a = ((t1 + t2) & _B32); pass;
						# Update the hash value with the compressed chunk.
						h0 = (h0 + a) & _B32; h1 = (h1 + b) & _B32; h2 = (h2 + c) & _B32; h3 = (h3 + d) & _B32;
						h4 = (h4 + e) & _B32; h5 = (h5 + f) & _B32; h6 = (h6 + g) & _B32; h7 = (h7 + h) & _B32; pass;
					# Produce the final hash value (big-endian).
					var digest: PoolByteArray = PoolByteArray (); digest.resize (32); j = 0;
					for i in _U32_SHIFTS:
						digest [j] = (h0 >> i) & 0xff; digest [(j + 4)] = (h1 >> i) & 0xff; digest [(j + 8)] = (h2 >> i) & 0xff;
						digest [(j + 12)] = (h3 >> i) & 0xff; digest [(j + 16)] = (h4 >> i) & 0xff;
						digest [(j + 20)] = (h5 >> i) & 0xff; digest [(j + 24)] = (h6 >> i) & 0xff;
						digest [(j + 28)] = (h7 >> i) & 0xff; j += 1;
					# Return the final value.
					return bytes_to_text (digest);
		# For HASHMAC SHA256 method.
		elif method == HashingMethod.HASHMAC_SHA256:
			# For RAW schema.
			if schema >= EncryptionSchema.RAW:
				# Keys shorter than hash size are padded to hash size by padding with zeros on the right.
				if key.length () > 64: key = hash_var (key, '', 1, 2); var ky: PoolByteArray = key.to_ascii ();
				# If the bytes array size is less than 64.
				while (ky.size () < 64): ky.append (0x00);
				# If an error has been detected.
				if ky.size () != 64: _output ("An error has been detected on hasing.", Message.WARNING);
				# Otherwise.
				else:
					# Generate inner and outer padding keys.
					var outer: PoolByteArray = PoolByteArray (); var inner: PoolByteArray = PoolByteArray ();
					for i in range (ky.size ()):
						# Update outer and inner.
						outer.append (ky [i] ^ 0x5c); inner.append (ky [i] ^ 0x36);
					# Contains the entry to passed.
					var entry: String = hash_var (bytes_to_text (inner + input.to_ascii ()), '', 1, 2);
					# Return the final result.
					return hash_var (bytes_to_text (outer + entry.to_ascii ()), '', 1, 2);
		# For Godot SHA256 method.
		elif method == HashingMethod.GODOT_SHA256: return input.sha256_text ();
		# For MD5 method.
		elif method == HashingMethod.MD5: return input.md5_text ();
		# For AES method.
		elif method == HashingMethod.AES:
			# BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return encrypt (input, key, EncryptionMethod.AES, EncryptionSchema.BASE64);
			# HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return encrypt (input, key, EncryptionMethod.AES, EncryptionSchema.HEXADECIMAL);
			# RAW schema.
			else: return encrypt (input, key, EncryptionMethod.AES, EncryptionSchema.RAW);
		# For ARCFOUR method.
		elif method == HashingMethod.ARCFOUR:
			# BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return encrypt (input, key, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
			# HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return encrypt (input, key, EncryptionMethod.ARCFOUR, EncryptionSchema.HEXADECIMAL);
			# RAW schema.
			else: return encrypt (input, key, EncryptionMethod.ARCFOUR, EncryptionSchema.RAW);
		# For CHACHA method.
		else:
			# BASE64 schema.
			if schema <= EncryptionSchema.BASE64: return encrypt (input, key, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
			# HEX schema.
			elif schema == EncryptionSchema.HEXADECIMAL: return encrypt (input, key, EncryptionMethod.CHACHA, EncryptionSchema.HEXADECIMAL);
			# RAW schema.
			else: return encrypt (input, key, EncryptionMethod.CHACHA, EncryptionSchema.RAW);
	# Return a fake value.
	return "Null";

"""
	@Description: Returns the conresponding type from his string format. The supported types are: Integer, Float, Vector2, Vector3,
		String, Boolean, Array and Dictionary. This method can take nested dictionaires and arrays.
	@Parameters:
		String variant: Contains a variant as string format.
"""
static func get_variant (variant: String):
	# Remove left and right spaces.
	variant = str_replace (variant, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
	# If the variant value is not empty.
	if variant != null and not variant.empty ():
		# For integer format.
		if variant.find (' ') == -1 and is_full_numbers (variant.lstrip ('-').lstrip ('+')): return int (variant);
		# For vector format.
		elif variant.begins_with ('(') and variant.ends_with (')') and variant.find (',') != -1:
			# Correct the vector representation.
			variant = variant.lstrip ('(').rstrip (')'); var vect: PoolStringArray = variant.split (',');
			# For vector2 format.
			if vect.size () == 2: return Vector2 (float (vect [0]), float (vect [1]));
			# For vector3 format.
			else: return Vector3 (float (vect [0]), float (vect [1]), float (vect [2]));
		# For boolean format.
		elif variant.to_lower () == "false" or variant.to_lower () == "true": return (true if variant.to_lower () == "true" else false);
		# For float format.
		elif variant.find ('.') != -1 && is_full_numbers (variant.split ('.') [0].lstrip ('-').lstrip ('+')) && is_full_numbers (variant.split ('.') [1]):
			# Split the current string in two parts.
			var nums: PoolStringArray = variant.split ('.');
			# Return the final result.
			return float (str (int (nums [0].lstrip (' ').rstrip (' '))) + '.' + str (int (nums [1].lstrip (' ').rstrip (' '))));
		# For exp float format.
		elif variant.find ('e') != -1 && is_number (get_variant (variant.split ('e') [0])) && is_number (get_variant (variant.split ('e') [1])):
			# Return the final result after calculating.
			return float (variant);
		# For an array.
		elif variant.begins_with ('[') and variant.ends_with (']'):
			# Contains the final result.
			var result: Array = Array ([]); variant [0] = ''; variant [(len (variant) - 1)] = '';
			# The array is not empty.
			if variant.find (',') != -1:
				# Check the given array.
				if variant.count ('[') == variant.count (']') && variant.count ('{') == variant.count ('}') && variant.count ('(') == variant.count (')'):
					# Initialize elements.
					variant = variant.replace (", ", ','); var state: int = -1; var nested: int = 0; var varit: PoolStringArray = variant.split (',');
					# Convert the passed variant into an array.
					for j in varit.size ():
						# Remove left and right spaces.
						varit [j] = varit [j].lstrip (' ').rstrip (' '); varit [j] = ' ' if varit [j].empty () else varit [j];
						# Contains the last character of the current string and calculate the preview index.
						var last_chr: String = varit [j] [(varit [j].length () - 1)]; var k: int = (j - 1);
						# Checks all main characters from the current string.
						var re: Array = Array ([
							varit [j].find ('(') != -1, varit [j].find_last (')') != -1, varit [j].find ('[') != -1,
							varit [j].find_last (']') != -1, varit [j].find ('{') != -1, varit [j].find_last ('}') != -1
						]);
						# For other variables.
						if state == -1 && !re [0] && !re [1] && !re [2] && !re [3] && !re [4] && !re [5]: result.append (get_variant (varit [j]));
						# For vectors.
						if state == -1 || state == 0:
							# Check whether there are some characters '(' and ')' on the current string and generate the vector.
							nested += varit [j].count ('(') if varit [j] [0] == '(' else 0; nested -= varit [j].count (')') if last_chr == ')' else 0;
							varit [j] = (varit [k] + ',' + varit [j]) if state == 0 && k >= 0 && nested >= 0 && varit [k] [0] == '(' else varit [j];
							# Vector is detected.
							state = 0 if nested > 0 else -1; last_chr = varit [j] [(varit [j].length () - 1)];
							if nested == 0 && varit [j] [0] == '(' && last_chr == ')': result.append (get_variant (varit [j]));
						# For nested list.
						if state == -1 || state == 1:
							# Check whether there are some characters '[' and ']' on the current string and generate array.
							nested += varit [j].count ('[') if varit [j] [0] == '[' else 0; nested -= varit [j].count (']') if last_chr == ']' else 0;
							varit [j] = (varit [k] + ',' + varit [j]) if state == 1 && k >= 0 && nested >= 0 && varit [k] [0] == '[' else varit [j];
							# Nested array is detected.
							state = 1 if nested > 0 else -1; if nested == 0 && varit [j] [0] == '[' && last_chr == ']': result.append (get_variant (varit [j]));
						# For nested dictionary.
						if state == -1 || state == 2:
							# Check whether there are some characters '{' and '}' on the current string and generate dictionary.
							nested += varit [j].count ('{') if varit [j].find ('{') != -1 else 0;
							nested -= varit [j].count ('}') if varit [j].find_last ('}') != -1 else 0;
							varit [j] = (varit [k] + ',' + varit [j]) if state == 2 && k >= 0 && nested >= 0 && varit [k].find ('{') != -1 else varit [j];
							# Nested dictionary is detected.
							state = 2 if nested > 0 else -1; if nested == 0 && varit [j] [0] == '{' && last_chr == '}': result.append (get_variant (varit [j]));
					# Return the final result.
					return result;
				# Otherwise.
				else: _output ("Syntax error. Check your value and make sure that it respects basics types nomenclatures.", Message.ERROR);
			# Check variant size.
			else: return Array ([get_variant (variant)]) if variant.length () > 0 else result;
		# For a dictionary.
		elif variant.begins_with ('{') and variant.ends_with ('}'):
			# Correct the given dictionary by putting some markers.
			variant = variant.replace (", ", ','); variant = variant.replace ('{', "{@dic:'',");
			variant = variant.replace ('}', ",@dic:''}"); variant = variant.replace ('[', "[@ary,");
			variant = variant.replace (']', ",@ary]"); variant = variant.replace ('=', ':');
			variant = variant.replace ('{', '['); variant = variant.replace ('}', ']');
			variant = variant.replace (':', ','); var real_array: Array = get_variant (variant);
			real_array.pop_back (); real_array.pop_back (); real_array.pop_front (); real_array.pop_front ();
			# Contains the final result.
			var result: Dictionary = Dictionary ({});
			# Generating the corresponding dictionary.
			for i in range (0, (real_array.size () - 1), 2):
				# The current key is an array.
				if real_array [i] is Array:
					# For an nested array.
					if real_array [i] [0] == "@ary":
						# Remove array borders.
						real_array [i].pop_front (); real_array [i].pop_back ();
					# Common configurations.
					real_array [i] = str (real_array [i]); real_array [i] = real_array [i].replace ("[@ary, ", '[');
					real_array [i] = real_array [i].replace (", @ary]", ']'); real_array [i] = real_array [i].replace ("[@dic, '', ", '{');
					real_array [i] = real_array [i].replace (", @dic, '']", '}'); real_array [i] = get_variant (real_array [i]);
				# The current value is an Array.
				if real_array [(i + 1)] is Array:
					# For an nested array.
					if real_array [(i + 1)] [0] == "@ary":
						# Remove array borders.
						real_array [(i + 1)].pop_front (); real_array [(i + 1)].pop_back ();
					# Common configurations.
					real_array [(i + 1)] = str (real_array [(i + 1)]); real_array [(i + 1)] = real_array [(i + 1)].replace ("[@ary, ", '[');
					real_array [(i + 1)] = real_array [(i + 1)].replace (", @ary]", ']'); real_array [(i + 1)] = real_array [(i + 1)].replace ("[@dic, '', ", '{');
					real_array [(i + 1)] = real_array [(i + 1)].replace (", @dic, '']", '}'); real_array [(i + 1)] = get_variant (real_array [(i + 1)]);
				# Add the final result to the created dictionary.
				result [real_array [i]] = real_array [(i + 1)];
			# Return the final result.
			return result;
		# For string format.
		else: return variant;
	# Otherwise.
	else: return null;

"""
	@Description: Creates a file on the computer disk that contains the given data. This method can only save a dictionary.
	@Parameters:
		Dictionary data: Contains all useful data that will be saved.
		String path: Where want you create the save file ?
		Node obj: Which knot will be considered to make the differents operations ?
		String ky: What is password of data ? The key size must be in range (0, 32).
		int mhd: What is your prefered security method ? The supported methods are:
			-> MegaAssets.SecurityMethod.NONE or 0: No security will be applied to data.
			-> MegaAssets.SecurityMethod.AES or 1: Data encryption with AES method.
			-> MegaAssets.SecurityMethod.ARCFOUR or 2: Data encryption with ARCFOUR method.
			-> MegaAssets.SecurityMethod.CHACHA or 3: Data encryption with CHACHA method.
			-> MegaAssets.SecurityMethod.BINARY or 4: Coding data to 2 bits.
			-> MegaAssets.SecurityMethod.HEXADECIMAL or 5: Coding data to 16 bits.
			-> MegaAssets.SecurityMethod.OCTAL or 6: Coding data to 8 bits.
			-> MegaAssets.SecurityMethod.GODOT or 7: Data encryption with GODOT method.
		int lv: Which security level want you use ? The supported levels are:
			-> MegaAssets.SecurityLevel.SIMPLE or 0: Simple level security.
			-> MegaAssets.SecurityLevel.NORMAL or 1: Normal level security.
			-> MegaAssets.SecurityLevel.ADVANCED or 2: Advanced level security.
		Dictionary call: Contains information on the method to be executed while saving a file. This dictionary supports keys following:
			-> String | NodePath source: Contains the address from method to targeted. The presence of this key is not mandatory. In this case, we
				considered that the referred method is on the one found in the "obj" parameter.
			-> String method: Contains the name of the method to executed. The use of this key is mandatory.
			Note that the method to be executed must have three (03) parameters namely:
			-> String path: Will contain the name of the file in backup course.
			-> int progress: Will contain the current progress of file being backed up.
			-> Variant error: Will contain the error triggered at during data backup. This parameter will return you a dictionary containing
				the keys: "message", "code" and "type" or null if no error occurred during data saving.
		int chek: What is your prefered method for the checksum of the save file ? The supported methods are:
			-> MegaAssets.Checksum.NONE or 0: No checksum will be generated.
			-> MegaAssets.Checksum.MD5 or 1: The checksum will be generated by using MD5 encryption method.
			-> MegaAssets.Checksum.SHA256 or 2: The checksum will be generated by using SHA256 encryption method.
		float delay: What is the timeout before saving data ?
"""
static func serialize (data: Dictionary, path: String, obj: Node, ky: String = '', mhd: int = 7, lv: int = 1, call: Dictionary = Dictionary ({}),
chek: int = Checksum.NONE, delay: float = 0.0) -> void:
	# Checks data size.
	if data.size () > 0:
		# Corrects path separator and removes all spaces.
		path = path.replace ('\\', '/').replace (' ', '');
		# Check path value.
		if path != null && path.find_last ('.') != -1:
			# Waiting for user delay.
			if !Engine.editor_hint && delay > 0.0: yield (obj.get_tree ().create_timer (delay), "timeout");
			# Create all useful folders to generate the save file.
			create_folders_from (path, obj); var file: File = File.new (); var fname: String = path.get_file ();
			# If GODOT method is not choosed or choosed.
			if mhd != SecurityMethod.GODOT || mhd == SecurityMethod.GODOT and lv <= SecurityLevel.SIMPLE:
				# Open the file as WRITE mode.
				if file.open (path, File.WRITE) != OK: _callback_manager (call, Array ([path, 0, Dictionary ({
					"message": ("Failed to open {" + fname + "}."), "code": ERR_FILE_CANT_OPEN, "type": Message.WARNING
				})]), true, obj);
			# Otherwise.
			else:
				# For Normal level.
				if lv == SecurityLevel.NORMAL:
					 # Open the file in WRITE encrypted mode.
					if file.open_encrypted_with_pass (path, File.WRITE, ky) != OK: _callback_manager (call, Array ([path, 0, Dictionary ({
						"message": ("Failed to open {" + fname + "}."), "code": ERR_FILE_CANT_OPEN, "type": Message.WARNING
					})]), true, obj);
				# Otherwise.
				else:
					# Correct the passed key.
					while ky.length () < 32: ky += ' ';
					# Open the file in WRITE encrypted mode.
					if file.open_encrypted (path, File.WRITE, ky.to_ascii ()) != OK: _callback_manager (call, Array ([path, 0, Dictionary ({
						"message": ("Failed to open {" + fname + "}."), "code": ERR_FILE_CANT_OPEN, "type": Message.WARNING
					})]), true, obj);
			# Check whether Godot method is choosed.
			if mhd == SecurityMethod.GODOT:
				# Update saving progress callback.
				_callback_manager (call, Array ([path, 0, null]), false, obj);
				# Check level value.
				if lv <= SecurityLevel.SIMPLE:
					# If the extension of the save file is (.json).
					if path.ends_with (".json"): file.store_line (JSON.print (data, "\t")); else: file.store_line (str (data));
				# Otherwise.
				else:
					# If the extension of the save file is (.json).
					if path.ends_with (".json"): file.store_var (JSON.print (data, "\t")); else: file.store_var (data);
				# Update saving progress callback.
				_callback_manager (call, Array ([path, 100, null]), false, obj);
			# Godot method is not choosed.
			else:
				# Contains all data as json format.
				var json_data: PoolStringArray = PoolStringArray ([]); var keys: Array = data.keys (); var progress: float = 0.0;
				# Store each data into the save file from the given dictionary.
				for k in range (keys.size ()):
					# Item value must not be equal to @path or @subpath.
					if str (keys [k]).find ("@path") == -1 and str (keys [k]).find ("@subpath") == -1:
						# Contains the final data that will be saved.
						if !Engine.editor_hint: yield (obj.get_tree (), "idle_frame"); var inpt: String = (str (keys [k]) + "~||~" + str (data [keys [k]]));
						# Calculate the saving progress.
						progress = (float (k * 100) / len (keys));
						# For AES method.
						if mhd == SecurityMethod.AES:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = encrypt (inpt, ky, EncryptionMethod.AES, EncryptionSchema.BASE64);
							# For normal level.
							elif lv == SecurityLevel.NORMAL:
								# Encrypt the given data to Hex.
								inpt = encrypt (inpt, ky, EncryptionMethod.AES, EncryptionSchema.HEXADECIMAL);
								# Code the encrypted data to binary.
								inpt = _string_to_bit (inpt, 2, false);
							# For advanced level.
							else:
								# Encrypt the given data to RAW.
								inpt = encrypt (inpt, ky, EncryptionMethod.AES, EncryptionSchema.RAW);
								# Code the encrypted data to hexadecimal.
								inpt = _string_to_bit (inpt, 16, true);
						# For ARCFOUR method.
						elif mhd == SecurityMethod.ARCFOUR:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = encrypt (inpt, ky, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
							# For normal level.
							elif lv == SecurityLevel.NORMAL:
								# Encrypt the given data to Hex.
								inpt = encrypt (inpt, ky, EncryptionMethod.ARCFOUR, EncryptionSchema.HEXADECIMAL);
								# Code the encrypted data to binary.
								inpt = _string_to_bit (inpt, 2, false);
							# For advanced level.
							else:
								# Encrypt the given data to RAW.
								inpt = encrypt (inpt, ky, EncryptionMethod.ARCFOUR, EncryptionSchema.RAW);
								# Code the encrypted data to hexadecimal.
								inpt = _string_to_bit (inpt, 16, true);
						# For CHACHA method.
						elif mhd == SecurityMethod.CHACHA:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = encrypt (inpt, ky, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
							# For normal level.
							elif lv == SecurityLevel.NORMAL:
								# Encrypt the given data to Hex.
								inpt = encrypt (inpt, ky, EncryptionMethod.CHACHA, EncryptionSchema.HEXADECIMAL);
								# Code the encrypted data to binary.
								inpt = _string_to_bit (inpt, 2, false);
							# For advanced level.
							else:
								# Encrypt the given data to RAW.
								inpt = encrypt (inpt, ky, EncryptionMethod.CHACHA, EncryptionSchema.RAW);
								# Code the encrypted data to hexadecimal.
								inpt = _string_to_bit (inpt, 16, true);
						# For BINARY method.
						elif mhd == SecurityMethod.BINARY:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = _string_to_bit (inpt, 2, false);
							# For normal level.
							elif lv == SecurityLevel.NORMAL: inpt = _string_to_bit (inpt, 2, true);
							# For advanced level.
							else:
								# Encrypt the given data to BASE64.
								inpt = encrypt (inpt, ky, EncryptionMethod.AES, EncryptionSchema.BASE64);
								# Code the encrypted data to binary.
								inpt = _string_to_bit (inpt, 2, true);
						# For HEXADECIMAL method.
						elif mhd == SecurityMethod.HEXADECIMAL:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = _string_to_bit (inpt, 16, false);
							# For normal level.
							elif lv == SecurityLevel.NORMAL: inpt = _string_to_bit (inpt, 16, true);
							# For advanced level.
							else:
								# Encrypt the given data to BASE64.
								inpt = encrypt (inpt, ky, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
								# Code the encrypted data to hexadecimal.
								inpt = _string_to_bit (inpt, 16, true);
						# For OCTAL method.
						elif mhd == SecurityMethod.OCTAL:
							# For simple level.
							if lv <= SecurityLevel.SIMPLE: inpt = _string_to_bit (inpt, 8, false);
							# For normal level.
							elif lv == SecurityLevel.NORMAL: inpt = _string_to_bit (inpt, 8, true);
							# For advanced level.
							else:
								# Encrypt the given data to HEX.
								inpt = encrypt (inpt, ky, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
								# Code the encrypted data to octal.
								inpt = _string_to_bit (inpt, 8, true);
						# If the extension of the save file is (.json).
						if path.ends_with (".json"): json_data.append (inpt); else: file.store_line (inpt);
						# Update saving progress callback.
						_callback_manager (call, Array ([path, int (progress), null]), false, obj);
				# For json format.
				if path.ends_with (".json"): file.store_string (JSON.print (json_data, "\t")); file.close ();
				# There are a security.
				if chek > Checksum.NONE:
					# Creating the checksum file.
					var fchecksum: File = File.new ();
					# Open the checksum file as WRITE mode.
					if fchecksum.open ((OS.get_user_data_dir () + '/' + fname.split ('.') [0] + ".sum"), File.WRITE) != OK:
						# Error message.
						_callback_manager (call, Array ([path, int (progress), Dictionary ({
							"message": ("Failed to generate the checksum file of {" + fname + "}."), "code": ERR_FILE_CANT_WRITE, "type": Message.ERROR
						})]), true, obj);
					# No errors detected.
					else:
						# For MD5 checksum generation.
						if chek == Checksum.MD5: fchecksum.store_line (file.get_md5 (path));
						# For SHA256 checksum generation.
						elif chek >= Checksum.SHA256: fchecksum.store_line (file.get_sha256 (path));
						# Update saving progress callback.
						fchecksum.close (); _callback_manager (call, Array ([path, 100, null]), false, obj);
				# Otherwise.
				else: _callback_manager (call, Array ([path, 100, null]), false, obj);
		# Warning message.
		else: _output ("Invalid path.", Message.WARNING);
	# Warning message.
	else: _output ("The data mustn't be empty.", Message.WARNING);

"""
	@Description: Returns a deserialized dictionary from a save file. Pay attention ! The file will have to be generated by using "serialize ()" method.
	@Parameters:
		String path: Where found the save file ?
		String key: What is password of the file data ? The key size must be in range (0, 32).
		Node obj: Which knot will be considered to make the differents operations ?
		int mhd: What is the security method that has been used to save data ? The supported methods are:
			-> MegaAssets.SecurityMethod.NONE or 0: No security will be applied to data.
			-> MegaAssets.SecurityMethod.AES or 1: Data encryption with AES method.
			-> MegaAssets.SecurityMethod.ARCFOUR or 2: Data encryption with ARCFOUR method.
			-> MegaAssets.SecurityMethod.CHACHA or 3: Data encryption with CHACHA method.
			-> MegaAssets.SecurityMethod.BINARY or 4: Coding data to 2 bits.
			-> MegaAssets.SecurityMethod.HEXADECIMAL or 5: Coding data to 16 bits.
			-> MegaAssets.SecurityMethod.OCTAL or 6: Coding data to 8 bits.
			-> MegaAssets.SecurityMethod.GODOT or 7: Data encryption with GODOT method.
		int level: Which security levels has been used on the save file ? The supported levels are:
			-> MegaAssets.SecurityLevel.SIMPLE or 0: Simple level security.
			-> MegaAssets.SecurityLevel.NORMAL or 1: Normal level security.
			-> MegaAssets.SecurityLevel.ADVANCED or 2: Advanced level security.
		Dictionary call: Contains information on the method to be executed while loading a file. This dictionary supports keys following:
			-> String | NodePath source: Contains the address of the method to targeted. The presence of this key is not mandatory. In this case,
				we consider that the referred method is on the one in the "obj" parameter.
			-> String method: Contains the name of the method to executed. The use of this key is mandatory.
			Note that the method to be executed must have five (05) parameters namely:
			-> String path: Will contain the path of the file in loading.
			-> bool is_loading: Is the current file actually loading ?
			-> int progress: Will contain the number of item (s) already loaded into memory.
			-> Dictionary result: Will contain all data loaded from the file in question.
			-> Variant error: Will contain the error triggered at during data loading. This parameter will return you a dictionary containing
				the keys: "message", "code" and "type" or null if no error occurred during data backup.
		int check: What is the checksum that has been used on the save file ? The supported methods are:
			-> MegaAssets.Checksum.NONE or 0: No checksum will be generated.
			-> MegaAssets.Checksum.MD5 or 1: The checksum will be generated by using MD5 encryption method.
			-> MegaAssets.Checksum.SHA256 or 2: The checksum will be generated by using SHA256 encryption method.
"""
static func deserialize (path: String, obj: Node, key: String = '', mhd: int = 7, level: int = 1, call: Dictionary = Dictionary ({}), check: int = 0) -> Dictionary:
	# Corrects path separator and removes all spaces.
	path = path.replace ('\\', '/').replace (' ', '');
	# Check path value.
	if path != null && path.find_last ('.') != -1:
		# Create a file his checksum file.
		var file: File = File.new (); var fchecksum: File = File.new (); var fname: String = path.get_file ();
		# Update loading progress callback with the created decrypted data.
		var decrypted_data: Dictionary = Dictionary ({}); _callback_manager (call, Array ([path, true, 0, decrypted_data, null]), false, obj);
		# If the path to the target save file is invalid.
		if not file.file_exists (path): _callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
			"message": ("The file {" + fname + "} doesn't exists."), "code": ERR_FILE_NOT_FOUND, "type": Message.WARNING
		})]), true, obj);
		# Check Godot Method.
		elif mhd == SecurityMethod.GODOT and level > SecurityLevel.SIMPLE:
			# Contains the save file state.
			var file_state: int = -1;
			# Normal level.
			if level == SecurityLevel.NORMAL: file_state = file.open_encrypted_with_pass (path, File.READ, key);
			# Advanced level.
			else:
				# Correct the passed key and open the file in encrypted READ mode.
				while key.length () < 32: key += ' '; file_state = file.open_encrypted (path, File.READ, key.to_ascii ());
			# There some warning.
			if file_state != OK:
				# If the file is corrupted.
				if file_state == ERR_FILE_CORRUPT: _callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
					"message": ("The file {" + fname + "} is corrupted."), "code": ERR_FILE_CORRUPT, "type": Message.WARNING
				})]), true, obj);
				# Warning message.
				else: _callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
					"message": ("Failed to open {" + fname + "}."), "code": ERR_FILE_CANT_OPEN, "type": Message.WARNING
				})]), true, obj);
			# No errors detected.
			else:
				# For json format.
				if path.ends_with (".json"): decrypted_data = JSON.parse (file.get_var ()).result;
				# Other format.
				else: decrypted_data = file.get_var (); file.close ();
				# Update loading progress callback.
				_callback_manager (call, Array ([path, false, decrypted_data.size (), decrypted_data, null]), false, obj); return decrypted_data;
		# Open the file as READ mode.
		elif file.open (path, File.READ) != OK: _callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
			"message": ("Failed to open {" + fname + "}."), "code": ERR_FILE_CANT_OPEN, "type": Message.WARNING
		})]), true, obj);
		# Godot method is choosed.
		elif mhd == SecurityMethod.GODOT and level <= SecurityLevel.SIMPLE:
			# If json format is used.
			if path.ends_with (".json"):
				# Return thr final value.
				decrypted_data = JSON.parse (file.get_as_text ()).result; file.close ();
				# Update loading progress callback.
				_callback_manager (call, Array ([path, false, decrypted_data.size (), decrypted_data, null]), false, obj); return decrypted_data;
			# For other format.
			else:
				# Generate the corresponding data of the passed string.
				decrypted_data = get_variant (file.get_as_text ());
				# Update loading progress callback.
				_callback_manager (call, Array ([path, false, decrypted_data.size (), decrypted_data, null]), false, obj); return decrypted_data;
		# Open the target checksum file as READ mode.
		elif check > Checksum.NONE && fchecksum.open ((OS.get_user_data_dir () + '/' + fname.split ('.') [0] + ".sum"), File.READ) != OK:
			# Warning message.
			_callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
				"message": ("The checksum file of {" + fname + "} is not defined."), "code": ERR_FILE_NOT_FOUND, "type": Message.WARNING
			})]), true, obj);
		# For MD5 checksum.
		elif check == Checksum.MD5 && file.get_md5 (path) != fchecksum.get_line ():
			# Warning message.
			_callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
				"message": ("Failed to load {" + fname + "}. This file is corrupted."), "code": ERR_FILE_CORRUPT, "type": Message.WARNING
			})]), true, obj);
		# For SHA256 checksum.
		elif check >= Checksum.SHA256 && file.get_sha256 (path) != fchecksum.get_line ():
			# Warning message.
			_callback_manager (call, Array ([path, false, 0, decrypted_data, Dictionary ({
				"message": ("Failed to load {" + fname + "}. This file is corrupted."), "code": ERR_FILE_CORRUPT, "type": Message.WARNING
			})]), true, obj);
		# No warnings detected.
		else:
			# Contains all json data.
			var json_data: PoolStringArray = PoolStringArray ([]); var line: String = ''; var js_idx: int = 0; var js_dt_count: int = 0;
			# If the save file is a json file.
			if path.ends_with (".json"):
				# Contains all json data.
				json_data = JSON.parse (file.get_as_text ()).result;
				# Update the line value.
				line = json_data [0]; js_dt_count = json_data.size ();
			# Otherwise.
			else: line = file.get_line ();
			# While there are some data.
			while path.ends_with (".json") && js_idx < js_dt_count or !path.ends_with (".json") && !line.empty ():
				# Contains the final decrypted value of a datum.
				var data = null;
				# No security has put.
				if mhd <= SecurityMethod.NONE or mhd > SecurityMethod.OCTAL: data = line;
				# For AES method.
				elif mhd == SecurityMethod.AES:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (line, key, EncryptionMethod.AES, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.RAW);
				# For ARCFOUR method.
				elif mhd == SecurityMethod.ARCFOUR:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (line, key, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.RAW);
				# For CHACHA method.
				elif mhd == SecurityMethod.CHACHA:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (line, key, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.RAW);
				# For BINARY method.
				elif mhd == SecurityMethod.BINARY:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (line, 2, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (line, 2, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 2, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.BASE64);
				# For HEXADECIMAL method.
				elif mhd == SecurityMethod.HEXADECIMAL:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (line, 16, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (line, 16, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
				# For OCTAL method.
				elif mhd == SecurityMethod.OCTAL:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (line, 8, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (line, 8, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (line, 8, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
				# Getting the decrypted key and value.
				data = data.split ("~||~"); if data is PoolStringArray && data.size () == 2: decrypted_data [get_variant (data [0])] = get_variant (data [1]);
				# For json file format.
				if path.ends_with (".json"):
					# Update the line value.
					js_idx += 1; if js_idx < js_dt_count: line = json_data [js_idx];
				# For other file format.
				else: line = file.get_line ();
				# Update loading progress callback.
				_callback_manager (call, Array ([path, true, decrypted_data.size (), Dictionary ({}), null]), false, obj);
			# Close all files and return the final result.
			js_idx = 0; file.close (); fchecksum.close ();
			# Update loading progress callback.
			_callback_manager (call, Array ([path, false, decrypted_data.size (), decrypted_data, null]), false, obj); return decrypted_data;
	# Warning message.
	else: _output ("Invalid path.", Message.WARNING); return Dictionary ({});

"""
	@Description: Generates a color.
	@Parameters:
		bool use_alpha: Do you want to generate some colors without alpha color ?
"""
static func generate_color (use_alpha: bool = false) -> Color:
	# Make a randomize and return the final result.
	randomize (); return Color8 (randi () % 255, randi () % 255, randi () % 255, (randi () % 255 if use_alpha else 255));

"""
	@Description: Returns several nodes from their path.
	@Parameters:
		PoolStringArray nodes_paths: Contains all target nodes paths.
		Node object: Which knot will be considered to make the differents operations ?
		bool reversed: Do you want to inverse treatment ?
"""
static func get_nodes (nodes_paths: PoolStringArray, object: Node, reversed: bool = false) -> Array:
	# Contains the nodes paths size
	var size: int = nodes_paths.size ();
	# If the nodes paths array is not null.
	if size > 0:
		# Contains all found nodes from their path.
		var nodes: Array = Array ([]);
		# Get all target nodes.
		for v in range ((0 if !reversed else (size - 1)), (size if !reversed else -1), (1 if !reversed else -1)):
			# Contains the found node.
			var node: Node = object.get_node_or_null (NodePath (nodes_paths [v])); if node is Node: nodes.append (node);
		# Return the final result.
		return nodes;
	# Return a fake value.
	else: return Array ([]);

"""
	@Description: Adds a/some node(s) to other node. The specified node(s) has no parent before adding.
	@Parameters:
		PoolStringArray | String | NodePath nodes: Contains a/some node(s) path(s).
		String | NodePath other: Contains the node path which the target node(s) will be added.
		Node object: Which knot will be considered to make the differents operations ?
		bool reversed: Do you want to inverse treatment ?
		float delay: What is the timeout before adding node ?
		float interval: What is the timeout each add ?
"""
static func add_children (nodes, other, object: Node, reversed: bool = false, delay: float = 0.0, interval: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
	# Convert "nodes" parameter into a PoolStringArray.
	nodes = Array ([nodes]) if not is_array (nodes) else Array (nodes); nodes = PoolStringArray (nodes);
	# Gets the real passed node.
	other = object.get_node_or_null (other) if other is String or other is NodePath else other;
	# Check the current node value.
	if other is Node:
		# Add all passed node(s) to other node(s).
		for l in range ((0 if !reversed else (nodes.size () - 1)), (len (nodes) if !reversed else -1), (1 if !reversed else -1)):
			# Filter each item from the node list.
			nodes [l] = object.get_node_or_null (nodes [l]) if nodes [l] is String or nodes [l] is NodePath else nodes [l];
			# Check the current node value.
			if nodes [l] is Node:
				# Waiting for user interval time.
				if !Engine.editor_hint && interval > 0.0: yield (object.get_tree ().create_timer (interval), "timeout");
				# Ckeck parent of the current node.
				if nodes [l].get_parent () == null: other.add_child (nodes [l]);
				# Warning message.
				else: _output (('{' + nodes [l].name + "} node has a parent already."), Message.WARNING);
			# Otherwise.
			else: _output (("The current node doesn't exists::index " + str (l)), Message.ERROR);
	# Otherwise.
	else: _output ("The container node doesn't exists.", Message.ERROR);

"""
	@Description: Generates a/some name(s).
	@Parameters:
		int smin: Contains the min length of the name to generated.
		int smax: Contains the max length of the name to generated.
		int count: Contains total name count.
"""
static func name_generation (smin: int = 3, smax: int = 7, count: int = 1):
	# Contains all generated names.
	var generated_names: PoolStringArray = PoolStringArray ([]);
	# Generating names.
	for _s in range (count):
		# Contains the generated word length.
		var generated_length: int = 0; randomize (); generated_length = int (round (randi () % ((smax - smin) + smin)));
		# Contains the generated name value.
		var generated_name: String = ''; var last_letter: String = ''; var index: int = 0; var state: String = "INITIAL";
		# While the index value is less than generated length.
		while index < generated_length:
			# Contains possible transitions and objects.
			var transitions = []; var obj = []; for item in _TRANSITION [state]: transitions.append (item);
			# If the max length is less than 3.
			if (index - generated_length) < 3:
				# Updading transitions.
				transitions.erase ("COMPOSE"); transitions.erase ("DOUBLE_CONSONNE"); transitions.erase ("DOUBLE_VOYELLE"); randomize ();
			# Contains the state of the current index.
			var state_index = round (randi () % transitions.size ());
			var stat = transitions [state_index]; var letters_list = _LETTERS [stat]; randomize ();
			# Contains the current index letter.
			var letter_index = round (randi () % letters_list.size ());
			# Update obj.
			obj = [stat, letters_list [letter_index]]; state = obj [0]; last_letter = obj [1];
			# Generating name letter.
			generated_name += last_letter; index += last_letter.length ();
		# Return the generated name value.
		generated_names.append (generated_name.capitalize ());
	# Contains the generated names size.
	var size: int = generated_names.size ();
	# Return the final value.
	if count <= 0: return null; elif size == 1: return generated_names [0]; else: return generated_names;

"""@Description: Returns the author name of "Godot Mega Assets" framework."""
static func get_author_name () -> String: return "Obrymec";

"""@Description: Returns the license name of "Godot Mega Assets" framework."""
static func get_used_license () -> String: return "MIT";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/bases/megaassets";

"""@Description: Returns the editor version where "Godot Mega Assets" framework is compatible."""
static func get_compatibility () -> String: return "Godot 3.x.x";

"""@Description: Returns the version of the module."""
static func get_version () -> String: return "0.1.2";

"""@Description: Is the base class for all modules is serializable ?"""
static func is_saveable () -> bool: return false;

"""@Description: Is the module don't destroy mode ?"""
static func is_dont_destroy_mode () -> bool: return false;

"""@Description: What is the supported platforms of this module ?"""
static func get_supported_platforms () -> String: return "ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX";

"""@Description: What is the supported dimensions of this module ?"""
static func get_supported_dimensions () -> String: return "2D || 3D";

"""@Description: Returns a module class type."""
func get_class (): return "MegaAssets";

"""
	@Description: Saves a dictionary in a config file.
	@Parameters:
		Dictionary data: Contains all data that will be saved.
		String path: Where do you want to save data ?
		Node object: Which knot will be considered to make the differents operations ?
		String key: Contains the password of saved data. The key size must be in range (0, 32).
		int security: Do you want to put a security to config file ? The possible values are:
			-> MegaAssets.SecurityLevel.SIMPLE or 0: Simple level security.
			-> MegaAssets.SecurityLevel.NORMAL or 1: Normal level security.
			-> MegaAssets.SecurityLevel.ADVANCED or 2: Advanced level security.
		Dictionary call: Contains information on the method to be executed while saving a file. This dictionary supports keys following:
			-> String | NodePath source: Contains the address from method to targeted. The presence of this key is not mandatory. In this case, we
				considered that the referred method is on the one found in the "object" parameter.
			-> String method: Contains the name of the method to executed. The use of this key is mandatory.
			Note that the method to be executed must have three (03) parameters namely:
			-> String path: Will contain the path of the file in backup course.
			-> int progress: Will contain the current progress of file being backed up.
			-> Variant error: Will contain the error triggered at during data backup. This parameter will return you a dictionary containing
				the keys: "message", "code" and "type" or null if no error occurred during data saving.
		float delay: What is the timeout before saving data ?
"""
static func save_config_file (data: Dictionary, path: String, object: Node, key: String = '', security: int = 0, call: Dictionary = Dictionary ({}),
delay: float = 0.0) -> void:
	# If data isn't empty.
	if data.size () > 0:
		# Waiting for user delay.
		if !Engine.editor_hint && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Corrects path separator and removes all spaces.
		path = path.replace ('\\', '/').replace (' ', '');
		# If path value is not empty.
		if path != null and not path.empty ():
			# Checks path value.
			if path.find_last ('.') != -1:
				# Checks file extension.
				if path.ends_with (".cfg"):
					# Creates all useful folders to generate config file.
					create_folders_from (path, object); var config_file: ConfigFile = ConfigFile.new ();
					# Contains the file name.
					var fname: String = path.get_file (); var keys: Array = data.keys (); var progress: float = 0.0;
					# Generating config file.
					for k in keys.size ():
						# Waiting for game idle frames.
						yield (object.get_tree (), "idle_frame");
						# If the key is a section.
						if typeof (data [keys [k]]) == TYPE_DICTIONARY and data [keys [k]].size () > 0:
							# Updatses config file.
							for item in data [keys [k]]: config_file.set_value (str (keys [k]), str (item), data [keys [k]] [item]);
						# Updates the saving progress and run the callback.
						progress = (float (k * 100) / len (keys)); _callback_manager (call, Array ([path, int (progress), null]), false, object);
					# If there are no security actived.
					if security <= SecurityLevel.SIMPLE:
						# Saves the config file normaly.
						if config_file.save (path) != OK: _callback_manager (call, Array ([path, int (progress), Dictionary ({
							"message": ("Failed to create {" + fname + "}."), "code": ERR_FILE_CANT_WRITE, "type": Message.WARNING
						})]), true, object);
						# Otherwise.
						else: _callback_manager (call, Array ([path, 100, null]), false, object);
					# Normal security.
					elif security == SecurityLevel.NORMAL:
						# Saves the config file with AES-256 encryption method.
						if config_file.save_encrypted_pass (path, key) != OK: _callback_manager (call, Array ([path, int (progress), Dictionary ({
							"message": ("Failed to create {" + fname + "}."), "code": ERR_FILE_CANT_WRITE, "type": Message.WARNING
						})]), true, object);
						# Otherwise.
						else: _callback_manager (call, Array ([path, 100, null]), false, object);
					# Advanced security.
					else:
						# Corrects the passed key.
						while key.length () < 32: key += ' ';
						# Saves the config file with AES-256 encryption method using 32 bits.
						if config_file.save_encrypted (path, key.to_ascii ()) != OK: _callback_manager (call, Array ([path, int (progress), Dictionary ({
							"message": ("Failed to create {" + fname + "}."), "code": ERR_FILE_CANT_WRITE, "type": Message.WARNING
						})]), true, object);
						# Otherwise.
						else: _callback_manager (call, Array ([path, 100, null]), false, object);
				# Error message.
				else: _output ("The extension of the config file must be (.cfg) format.", Message.ERROR);
			# Warning message.
			else: _output ("The file is not defined.", Message.WARNING);
		# Warning message.
		else: _output ("The path is not defined.", Message.WARNING);
	# Warning message.
	else: _output ("Data should'nt be empty.", Message.WARNING);

"""
	@Description: Loads a config file.
	@Parameters:
		String path: Where find the config file ? Pay attention ! The file will have to be generated by using "save_config_file ()" method.
		Node object: Which knot will be considered to make the differents operations ?
		String key: What is the password that has been used on saving data ? The key size must be in range (0, 32).
		int security: Have you put a security to config file last time ? The possible values are:
			-> MegaAssets.SecurityLevel.SIMPLE or 0: Simple level security.
			-> MegaAssets.SecurityLevel.NORMAL or 1: Normal level security.
			-> MegaAssets.SecurityLevel.ADVANCED or 2: Advanced level security.
		Dictionary call: Contains information on the method to be executed while loading a file. This dictionary supports keys following:
			-> String | NodePath source: Contains the address of the method to targeted. The presence of this key is not mandatory. In this case,
				we consider that the referred method is on the one in the "object" parameter.
			-> String method: Contains the name of the method to executed. The use of this key is mandatory.
			Note that the method to be executed must have four (04) parameters namely:
			-> String path: Will contain the path of the file in loading.
			-> int progress: Will contain the loading progress.
			-> Dictionary result: Will contain all data loaded from the file in question.
			-> Variant error: Will contain the error triggered at during data loading. This parameter will return you a dictionary containing
				the keys: "message", "code" and "type" or null if no error occurred during data backup.
"""
static func load_config_file (path: String, object: Node, key: String = '', security: int = SecurityLevel.SIMPLE, call: Dictionary = Dictionary ({})) -> Dictionary:
	# Corrects path separator and removes all spaces.
	path = path.replace ('\\', '/').replace (' ', '');
	# If path value is not empty.
	if path != null and not path.empty ():
		# Checks path value.
		if path.find_last ('.') != -1:
			# Checks file extension.
			if path.ends_with (".cfg"):
				# Contains the file name.
				var fname: String = path.get_file (); var result: Dictionary = Dictionary ({});
				# Checks whether the config file exists.
				if File.new ().file_exists (path):
					# Contains the config file.
					var config_file: ConfigFile = ConfigFile.new (); var conf_state;
					# If no security has been enabled.
					if security <= SecurityLevel.SIMPLE: conf_state = config_file.load (path);
					# Normal security has been put.
					elif security == SecurityLevel.NORMAL: conf_state = config_file.load_encrypted_pass (path, key);
					# Advanced security has been put.
					else:
						# Corrects the passed key and load the config file with AES-256 encryption method.
						while key.length () < 32: key += ' '; conf_state = config_file.load_encrypted (path, key.to_ascii ());
					# Loads the config file.
					if conf_state != OK:
						# If the file is corrupted.
						if conf_state == ERR_FILE_CORRUPT: _callback_manager (call, Array ([path, 0, result, Dictionary ({
							"message": ("The file {" + fname + "} is corrupted."), "code": ERR_FILE_CORRUPT, "type": Message.WARNING
						})]), true, object);
					# No errors detected.
					else:
						# Contains the file data as section format.
						var sections: PoolStringArray = config_file.get_sections ();
						# Generating result.
						for t in sections.size ():
							# Contains all values of a section.
							var section_values: Dictionary = Dictionary ({});
							# Assembling keys.
							for ky in config_file.get_section_keys (sections [t]): section_values [ky] = config_file.get_value (sections [t], ky, null);
							# Updates the section.
							result [sections [t]] = section_values;
							# Updates loading progress callback.
							_callback_manager (call, Array ([path, int (float (t * 100) / len (sections)), Dictionary ({}), null]), false, object);
						# Updates loading progress callback and return the final result.
						_callback_manager (call, Array ([path, 100, result, null]), false, object); return result;
				# Warning message.
				else: _callback_manager (call, Array ([path, 0, result, Dictionary ({
					"message": ("The file {" + fname + "} doesn't exists."), "code": ERR_FILE_NOT_FOUND, "type": Message.WARNING
				})]), true, object);
			# Error message.
			else: _output ("The extension of the config file must be (.cfg) format.", Message.ERROR);
		# Warning message.
		else: _output ("The file is not defined.", Message.WARNING);
	# Warning message.
	else: _output ("The path is not defined.", Message.WARNING); return Dictionary ({});

"""
	@Description: Creates the neccesary folders include in a path.
	@Parameters:
		String path: Contains the directories tree.
		Node object: Which knot will be considered to make the differents operations ?
		float delay: What is the timeout before creating folders ?
"""
static func create_folders_from (path: String, object: Node, delay: float = 0.0) -> void:
	# If the path is not empty.
	if path != null and not path.empty ():
		# Waiting for user delay.
		if !Engine.editor_hint && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Contains all root directories that will be created.
		var directory: Directory = Directory.new (); var root_folders: String = path.get_base_dir ();
		# Check root folders existance.
		if !directory.dir_exists (root_folders) && directory.make_dir_recursive (root_folders) != OK:
			# Error message.
			_output ("Failed to create folders. The access may be denied. Check your path.", Message.ERROR);
	# Warning message.
	else: _output ("The path is not defined.", Message.WARNING);

"""
	@Description: Converts an/some input(s) into a dictionary format.
	@Parameters:
		Variant input: Contains contains the value that will be parsed into a dictionary.
		bool reversed: Do you want to inverse treatment ?
"""
static func any_to_dic (input, reversed: bool = false) -> Dictionary:
	# Parse the given parameter into an array.
	input = Array ([input]) if !is_array (input) else input; var result: Dictionary = Dictionary ({});
	# Generating the final dic.
	for index in range ((0 if !reversed else (len (input) - 1)), (len (input) if !reversed else -1), (1 if !reversed else -1)):
		# If the current obj is a dictionary.
		if input [index] is Dictionary: for key in input [index]: result [key] = input [index] [key];
		# Otherwise.
		else: result [index] = input [index];
	# Return the final result.
	return result;

"""
	@Description: Converts an/some input(s) into an array format.
	@Parameters:
		Variant input: Contains contains the value that will be parsed into an array.
		int dic_property: which property want to put into the returned array ? (Only whether the passed input is a Dictionary). The supported values are:
			-> MegaAssets.DictionaryProperty.KEYS or 0: Target the dictionary keys.
			-> MegaAssets.DictionaryProperty.VALUES or 1: Target the dictionary values.
			-> MegaAssets.DictionaryProperty.BOTH or 2: Target the dictionary keys and values.
"""
static func any_to_array (input, dic_property: int = 1) -> Array:
	# If the input is already an array.
	if is_array (input): return input;
	# Otherwise.
	else:
		# For a string.
		if input is String:
			# Removes left and right spaces.
			input = input.lstrip (' ').rstrip (' '); var characters: Array = Array ([]);
			# Adding each character from the given string to characters array.
			for chr in input: characters.append (chr); return characters;
		# For a dictionary.
		elif input is Dictionary:
			# For dictionary key only.
			var array: Array = Array ([]); if dic_property <= DictionaryProperty.KEYS: for key in input: array.append (key);
			# For dictionary value only.
			elif dic_property == DictionaryProperty.VALUES: for value in input: array.append (input [value]);
			# For both.
			else:
				# Takes the key and value from the passed dictionary.
				for both in input:
					# Puts this data into the array.
					array.append (both); array.append (input [both]);
			# Returns the final result.
			return array;
		# Otherwise.
		else: return Array ([input]);

"""
	@Description: Triggers one or more event(s) at a time.
	@Parameters:
		Array data: Table of dictionaries managing configurations related to the different events that we want to support. The
			dictionary(ies) from this table, support the following keys:
			-> String event: Contains the name of the event to sets off.
			-> float delay: What is the dead time before calling the event in question.
			-> Array params: Contains the values ​​of the various parameters of the event in question.
		Node node: Contains the node from which the event(s) will be triggered.
		int scope: Contains the value of events scope. The supported values are:
			-> MegaAssets.WornEvents.NONE or 0: None scope.
			-> MegaAssets.WornEvents.CHILDREN_ONLY or 1: For node children only.
			-> MegaAssets.WornEvents.PARENTS_ONLY or 2: For node parent only.
			-> MegaAssets.WornEvents.ALL or 3: For all nodes around of the target node.
		bool recursive: Will the scope of the event(s) be recursive ?
		float delay: What is the timeout before throw ?
"""
static func raise_event (data, scope: Node, mode: int = WornEvents.PARENT_ONLY, recursive: bool = true, delay: float = 0.0, _run: bool = true) -> void:
	# The specified mode is not null.
	if mode > WornEvents.NONE:
		# The game is running.
		if !Engine.editor_hint:
			# If the game is not initialised.
			if delay == 0.0 && !is_game_initialised (): yield (scope.get_tree (), "idle_frame");
			# Otherwise.
			elif delay > 0.0: yield (scope.get_tree ().create_timer (delay), "timeout");
		# Converting data into an Array.
		data = Array ([data]) if not data is Array else data;
		# Check run value.
		if _run:
			# Run the main node events.
			for datum in data: if datum is Dictionary: _event_manger (datum, scope);
		# For the children only.
		if mode == WornEvents.CHILDREN_ONLY:
			# Getting all children of the given scope.
			for child in scope.get_children ():
				# Run all given events.
				for datum in data: if datum is Dictionary: _event_manger (datum, child);
				# Is it a recursive program ?
				if recursive and child.get_child_count () > 0: raise_event (data, child, mode, recursive, -1.0, false);
		# For the parents only.
		elif mode == WornEvents.PARENTS_ONLY:
			# Contains the parent of the curent node.
			var parent = scope.get_parent ();
			# Is it a child of the given parent ?
			if !recursive and parent is Node:
				# Run all given events.
				for datum in data: if datum is Dictionary: _event_manger (datum, parent);
			# Otherwise.
			elif recursive:
				# While the current parent is a Node.
				while parent is Node:
					# Run all given events.
					for datum in data: if datum is Dictionary: _event_manger (datum, parent);
					# Gets the parent of the current parent.
					parent = parent.get_parent ();
		# For all elements [parent(s) and child(ren)] node(s).
		else:
			# For the scope parent.
			raise_event (data, scope, WornEvents.PARENTS_ONLY, recursive, -1.0, false);
			# For the scope children.
			raise_event (data, scope, WornEvents.CHILDREN_ONLY, recursive, -1.0, false);

"""
	@Description: Returns the real time (HH : MM : SS) from seconds.
	@Parameters:
		int seconds: Contains the time as seconds format.
		String divider: Contains a divider that will be used to separate each number of the returned time.
		bool parse: Do you want to return the result as a PoolIntArray ?
"""
static func get_time_from (seconds: int, divider: String = ':', parse: bool = false):
	# Contains the approximative minute(s) value.
	var pre_sec := (seconds / 60.0); var minutes = int (pre_sec) if str (pre_sec).find ('.') == -1 else int (str (pre_sec).split ('.') [0]);
	# Contains the real remaining seconds.
	seconds = (seconds - (minutes * 60)); var pre_min = (minutes / 60.0);
	# Contains the real hour(s) and remaining minute(s).
	var hours = int (pre_min) if str (pre_min).find ('.') == -1 else int (str (pre_min).split ('.') [0]); minutes = (minutes - (hours * 60));
	# Checks parse value.
	if parse: return PoolIntArray ([hours, minutes, seconds]);
	# Otherwise.
	else:
		# Converts hours into string format.
		hours = ('0' + str (hours)) if len (str (hours)) == 1 else str (hours);
		# Converts minutes into string format.
		minutes = ('0' + str (minutes)) if len (str (minutes)) == 1 else str (minutes);
		# Converts seconds into string format.
		var second: String = ('0' + str (seconds)) if len (str (seconds)) == 1 else str (seconds);
		# Returns the final value.
		return (hours + 'h' + divider + minutes + "min" + divider + second + 's');

"""
	@Description: Returns the corresponding type name of the given input.
	@Parameters:
		Variant input: Contains an object.
"""
static func get_type (input) -> String:
	# Checking input value type.
	if typeof (input) == TYPE_NIL || input == null: return "Nil"; elif typeof (input) == TYPE_BOOL: return "bool";
	elif typeof (input) == TYPE_INT: return "int"; elif typeof (input) == TYPE_REAL: return "float";
	elif str (input) == '' || typeof (input) == TYPE_STRING: return "String"; elif typeof (input) == TYPE_VECTOR2: return "Vector2";
	elif typeof (input) == TYPE_RECT2: return "Rect2"; elif typeof (input) == TYPE_VECTOR3: return "Vector3";
	elif typeof (input) == TYPE_NODE_PATH: return "NodePath"; elif typeof (input) == TYPE_PLANE: return "Plane";
	elif typeof (input) == TYPE_QUAT: return "Quat"; elif typeof (input) == TYPE_TRANSFORM: return "Transform";
	elif typeof (input) == TYPE_AABB: return "AABB"; elif typeof (input) == TYPE_BASIS: return "Basis";
	elif typeof (input) == TYPE_COLOR: return "Color"; elif typeof (input) == TYPE_ARRAY: return "Array";
	elif typeof (input) == TYPE_TRANSFORM2D: return "Transform2D"; elif typeof (input) == TYPE_RID: return "Rid";
	elif typeof (input) == TYPE_DICTIONARY: return "Dictionary"; elif typeof (input) == TYPE_RAW_ARRAY: return "PoolByteArray";
	elif typeof (input) == TYPE_INT_ARRAY: return "PoolIntArray"; elif typeof (input) == TYPE_REAL_ARRAY: return "PoolRealArray";
	elif typeof (input) == TYPE_STRING_ARRAY: return "PoolStringArray"; elif typeof (input) == TYPE_VECTOR2_ARRAY: return "PoolVector2Array";
	elif typeof (input) == TYPE_VECTOR3_ARRAY: return "PoolVector3Array"; elif typeof (input) == TYPE_COLOR_ARRAY: return "PoolColorArray";
	elif typeof (input) == TYPE_OBJECT: return input.get_class (); else: return '';

"""
	@Description: Determinates whether an input is an array. Include PoolStringArray, PoolRealArray, etc...
	@Parameters:
		Variant input: Contains a variable type value.
"""
static func is_array (input) -> bool:
	# For PoolByteArray, PoolColorArray, PoolIntArray.
	if input is PoolByteArray || input is PoolColorArray || input is PoolIntArray: return true;
	# For PoolRealArray, PoolVector2Array, PoolVector3Array.
	elif input is PoolRealArray || input is PoolVector2Array || input is PoolVector3Array: return true;
	# For PoolStringArray, Array.
	elif input is PoolStringArray || input is Array: return true; else: return false;

"""
	@Description: Returns the corresponding line(s) from a search from a file. This function doesn't support normal and advanced level of Godot method.
	@Parameters:
		String | PoolStringArray inp: What do you which found from the target file ?
		String path: Where found the file ?
		String key: What is password of the file ? The key size must be in range (0, 32).
		bool case: Do you want to make a search with insensitive case ?
		int count: How many result(s) will be returned ? If this value is less than 0, you will get all found values.
		int mhd: What is the security method that have been used on the file ? The supported methods are:
			-> MegaAssets.SecurityMethod.NONE or 0: No security will be applied to data.
			-> MegaAssets.SecurityMethod.AES or 1: Data encryption with AES method.
			-> MegaAssets.SecurityMethod.ARCFOUR or 2: Data encryption with ARCFOUR method.
			-> MegaAssets.SecurityMethod.CHACHA or 3: Data encryption with CHACHA method.
			-> MegaAssets.SecurityMethod.BINARY or 4: Coding data to 2 bits.
			-> MegaAssets.SecurityMethod.HEXADECIMAL or 5: Coding data to 16 bits.
			-> MegaAssets.SecurityMethod.OCTAL or 6: Coding data to 8 bits.
			-> MegaAssets.SecurityMethod.GODOT or 7: Data encryption with GODOT method.
		int level: which security levels has been used on the file ? The supported levels are:
			-> MegaAssets.SecurityLevel.SIMPLE or 0: Simple level security.
			-> MegaAssets.SecurityLevel.NORMAL or 1: Normal level security.
			-> MegaAssets.SecurityLevel.ADVANCED or 2: Advanced level security.
"""
static func file_find (inp, path: String, key: String = '', case: bool = false, count: int = 1, mhd: int = SecurityMethod.GODOT, level: int = 1):
	# Corrects path separator and removes all spaces.
	path = path.replace ('\\', '/').replace (' ', ''); inp = Array ([inp]) if not is_array (inp) else Array (inp); inp = PoolStringArray (inp);
	# Check path value.
	if path != null && path.find_last ('.') != -1:
		# Create a file instance.
		var file: File = File.new (); var fname: String = path.get_file ();
		# Contains the final results.
		var results: PoolStringArray = PoolStringArray ([]); var fstate: int = -1;
		# If the path to the target save file is invalid.
		if not file.file_exists (path): _output (("The file {" + fname + "} doesn't exists."), Message.WARNING);
		# For Godot normal encryption method.
		elif mhd == SecurityMethod.GODOT && level == SecurityLevel.NORMAL: fstate = file.open_encrypted_with_pass (path, File.READ, key);
		# For Godot advanced encryption method.
		elif mhd == SecurityMethod.GODOT && level >= SecurityLevel.ADVANCED:
			# Correct the passed key and open the file in encrypted READ mode.
			while len (key) < 32: key += ' '; fstate = file.open_encrypted (path, File.READ, key.to_ascii ());
		# Open the file as READ mode.
		elif file.open (path, File.READ) != OK: _output (("Failed to open {" + fname + "}."), Message.WARNING);
		# There some warning.
		if mhd == SecurityMethod.GODOT && level > SecurityLevel.SIMPLE && fstate != OK:
			# If the file is corrupted.
			if fstate == ERR_FILE_CORRUPT: _output (("The file {" + fname + "} is corrupted."), Message.WARNING);
			# Warning message.
			else: _output (("Failed to open {" + fname + "}."), Message.WARNING);
		# Contains the first line of opened file.
		var line: String = file.get_line ();
		# While there are some data.
		while len (line) > 0 and count != 0:
			# Filter the current line to get more view.
			var filter: String = str_replace (line, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", '{', '}', '[', ']', ',', '"'], '');
			# Check line value.
			if filter.length () > 0:
				# Contains the final result.
				var data = null;
				# No security has put.
				if mhd <= SecurityMethod.NONE or mhd > SecurityMethod.OCTAL: data = filter;
				# For AES method.
				elif mhd == SecurityMethod.AES:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (filter, key, EncryptionMethod.AES, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.RAW);
				# For ARCFOUR method.
				elif mhd == SecurityMethod.ARCFOUR:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (filter, key, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.RAW);
				# For CHACHA method.
				elif mhd == SecurityMethod.CHACHA:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = decrypt (filter, key, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
					# For normal level.
					elif level == SecurityLevel.NORMAL:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 2, false);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.HEXADECIMAL);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.RAW);
				# For BINARY method.
				elif mhd == SecurityMethod.BINARY:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (filter, 2, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (filter, 2, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 2, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.AES, EncryptionSchema.BASE64);
				# For HEXADECIMAL method.
				elif mhd == SecurityMethod.HEXADECIMAL:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (filter, 16, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (filter, 16, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 16, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.ARCFOUR, EncryptionSchema.BASE64);
				# For OCTAL method.
				elif mhd == SecurityMethod.OCTAL:
					# For simple level.
					if level <= SecurityLevel.SIMPLE: data = _string_from_bit (filter, 8, false);
					# For normal level.
					elif level == SecurityLevel.NORMAL: data = _string_from_bit (filter, 8, true);
					# For advanced level.
					else:
						# Decoding the encrypted line.
						data = _string_from_bit (filter, 8, true);
						# Decrypting of the given decoded data.
						data = decrypt (data, key, EncryptionMethod.CHACHA, EncryptionSchema.BASE64);
				# Converts the current data as string format.
				data = str (data); var dup_dat: String = data.to_lower () if case else data;
				# Searches each input into the given decrypted string.
				for val in inp:
					# If ever a value from input is inside of the current line.
					if dup_dat.find (str (val).to_lower () if case else str (val)) != -1:
						# Add it to results array and get out of the for loop.
						results.append (data); break;
				# Whether the results size is equal to count.
				if count > 0 and results.size () == count: break;
			# Go to the next line.
			line = file.get_line ();
		# Returns the final value.
		if results.size () <= 0: return null; elif results.size () == 1: return results [0]; else: return results;
	# Warning message.
	else: _output ("Invalid path.", Message.WARNING); return null;

"""
	@Description: Returns the corresponding index of an item from an array or dictionary.
	@Parameters:
		Variant datum: Contains a key or value.
		Array | Dictionary | String input: Contains the search field.
		bool reversed: Do you want to inverse treatment ?
		bool recursive: Do you want to use a recursive program to find index of a element ?
"""
static func get_index_of (datum, input, reversed: bool = false, recursive: bool = true) -> int:
	# The given input is a dictionary or array.
	if input is Dictionary:
		# Getting dictionary keys and starting value of the for loop.
		var keys: Array = input.keys ();
		# Checks elements from the passed input.
		for m in range ((0 if !reversed else (len (keys) - 1)), (len (keys) if !reversed else -1), (1 if !reversed else -1)):
			# The current element is equal to the passed element.
			if typeof (keys [m]) == typeof (datum) && keys [m] == datum or typeof (input [keys [m]]) == typeof (datum) && input [keys [m]] == datum: return m;
			# The current element key is a dictionary.
			elif recursive && keys [m] is Dictionary && get_index_of (datum, keys [m], reversed, recursive) > -1: return m;
			# The current element key is an array.
			elif recursive && is_array (keys [m]) && get_index_of (datum, keys [m], reversed, recursive) > -1: return m;
			# The current element value is a dictionary.
			elif recursive && input [keys [m]] is Dictionary && get_index_of (datum, input [keys [m]], reversed, recursive) > -1: return m;
			# The current element value is an array.
			elif recursive && is_array (input [keys [m]]) && get_index_of (datum, input [keys [m]], reversed, recursive) > -1: return m;
	# For an array.
	elif is_array (input):
		# Checks elements from the passed input.
		for k in range ((0 if !reversed else (len (input) - 1)), (len (input) if !reversed else -1), (1 if !reversed else -1)):
			# The current element is equal to the passed element.
			if typeof (input [k]) == typeof (datum) && input [k] == datum: return k;
			# The current element is a dictionary.
			elif recursive && input [k] is Dictionary && get_index_of (datum, input [k], reversed, recursive) > -1: return k;
			# The current element is an array.
			elif recursive && is_array (input [k]) && get_index_of (datum, input [k], reversed, recursive) > -1: return k;
	# For a string.
	elif input is String and datum is String: return input.find (datum) if !reversed else input.find_last (datum); return -1;

"""
	@Description: Parses a date. If no date passed, the current system date will be used.
	@Parameters:
		String format: What is your prefered date format ? Your date format must contains characters: 'd' to show
			the day, 'm' to show month and 'y' to show year. Eg: "dd-mm-yy", "yy/mm/dd", "mm:yy", "dd yy", etc...
		Dictionary date: Contains the date data. These data must have some keys: day, month and year.
		bool to_letter: Do you want to get the corresponding month name of the passed month number ?
		bool parse: Will return the date as Dictionnary format with an additional key (bixestile).
"""
static func parse_date (format: String = "dd-mm-yy", date: Dictionary = Dictionary ({}), to_letter: bool = false, parse: bool = false):
	# Remove right and left spaces.
	format = str_replace (format, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' '], '');
	# Check the passed format value.
	if !format.empty ():
		# Get the now date whether no date is specify.
		date = OS.get_date (true) if len (date) <= 0 else date; date.bixestile = (date.year % 4) == 0 if date.has ("year") else false;
		# Get position index of target characters.
		var entry: Array = Array ([format.find ('d'), format.find ('m'), format.find ('y')]);
		var sp: String = ' '; var ent: PoolStringArray = PoolStringArray (['', '', '', '']); 
		# Searches a separator.
		for chr in format:
			if chr != 'd' && chr != 'm' && chr != 'y':
				sp = chr; break;
		# For the day position.
		if entry [0] != -1:
			if entry [0] < entry [1] && entry [0] < entry [2]: ent [0] = 'd'; elif entry [0] > entry [1] && entry [0] < entry [2]: ent [1] = 'd';
			elif entry [0] < entry [1] && entry [0] > entry [2]: ent [1] = 'd'; elif entry [0] > entry [1] && entry [0] > entry [2]: ent [2] = 'd';
		# For the month position.
		if entry [1] != -1:
			if entry [1] < entry [0] && entry [1] < entry [2]: ent [0] = 'm'; elif entry [1] > entry [0] && entry [1] < entry [2]: ent [1] = 'm';
			elif entry [1] < entry [0] && entry [1] > entry [2]: ent [1] = 'm'; elif entry [1] > entry [0] && entry [1] > entry [2]: ent [2] = 'm';
		# For the year position.
		if entry [2] != -1:
			if entry [2] < entry [0] && entry [2] < entry [1]: ent [0] = 'y'; elif entry [2] > entry [0] && entry [2] < entry [1]: ent [1] = 'y';
			elif entry [2] < entry [0] && entry [2] > entry [1]: ent [1] = 'y'; elif entry [2] > entry [0] && entry [2] > entry [1]: ent [2] = 'y';
		# For string format.
		if to_letter and date.has ("month") and date.month is int:
			# For week months.
			match date.month:
				1: date.month = "January"; 2: date.month = "February"; 3: date.month = "March"; 4: date.month = "April";
				5: date.month = "May"; 6: date.month = "June"; 7: date.month = "July"; 8: date.month = "August";
				9: date.month = "September"; 10: date.month = "October"; 11: date.month = "November"; 12: date.month = "December";
		# Parsing results.
		for idx in range (3):
			if ent [idx] == 'd': ent [idx] = str (date.day) if date.has ("day") else '';
			elif ent [idx] == 'm': ent [idx] = str (date.month) if date.has ("month") else '';
			elif ent [idx] == 'y': ent [idx] = str (date.year) if date.has ("year") else '';
			ent [idx] = ent [idx].insert (0, '0') if len (ent [idx]) == 1 else ent [idx]; ent [idx] = (ent [idx] + (sp if ent [idx].length () > 0 else ''));
		# Generating the parsed date.
		ent [3] = (ent [0] + ent [1] + ent [2]); var last: int = (ent [3].length () - 1); if last > -1 && ent [3] [last] == sp: ent [3] [last] = '';
		# Return the final value.
		if parse: return date; elif !parse && ent [3].length () > 0: return ent [3]; return null;
	# Otherwise.
	else: return null;

"""
	@Description: Runs severals actions pre-configured by the developer from a dictionary.
	@Parameters:
		Dictionary data: Contains all configurations about the targets slots. The possible values are:
			-> String | NodePath source: What is the source where action will be done ? If the source key is
				not defined, the current object instance will be used.
			-> String action: Contains the target action. (Required). Eg: "run_slot ({action = "my_var"})",
				"run_slot ({action = "my_var", value = "?other_var"})", etc...
			-> Variant value: Contains a property value. Use this key when the action affect a property. If this key
				is not defined, you will get value of the target property.
			-> Variant params = Array ([]): Contains all arguments values of the target method. Use this key when the action
				affect a method. If this key isn't defined, the target method will be called with no parameters.
		It is also possible instead of a fixed value: whether at the level of a property or parameters of a method,
		to refer the value of another property or of a result returned by a method recursively. To be able to do this,
		we must use a character string in which we will have a special character: '?' placed in front of the name of the
		property or of the method whose value will be used as the value to be assigned to said property or parameter
		of the method in question. When you want to act on a method during a trigger, it is necessary to put at the
		end, the characters "()" in order to distinguish between a property and a method. By default, the events of a
		module impose conditions that must be respected by all elements under their responsibility. It is possible to
		break these requirements by disabling them with the require key. This option is only available on destructible modules.
		Node object: Which knot will be considered to make the differents operations ?
"""
static func run_slot (data: Dictionary, object: Node):
	# Checks source and action keys existance.
	var src = (data.source if data.source is String || data.source is NodePath else object.get_path ()) if data.has ("source") else object.get_path ();
	src = object.get_node_or_null (NodePath (str (src))); var act: String = data.action if data.has ("action") && data.action is String else '';
	# Checks source value.
	if src is Node:
		# Checks action value.
		if !act.empty ():
			# Checks errors.
			if act.count ("()") <= 1:
				# The action key is not a method.
				if not act.ends_with ("()"):
					# Checks value key existance.
					var val = data.value if data.has ("value") else null;
					# The value is defined.
					if val != null:
						# The val of the value key is a string format.
						if val is String:
							# Checks errors.
							if val.count ("()") <= 1 and val.count ('?') <= 1:
								# The current value call other value from other variable.
								if val.lstrip (' ').begins_with ('?'):
									# Remove '?' character with left and right spaces.
									val = val.split ('?'); val = val [1] if not val [1].empty () else '';
									# The value of this value is not a method.
									if not val.ends_with ("()"): set_var (act, get_var (val, src), src);
									# It's a method.
									else:
										# Checks parameters key presence to generate the corresponding dictionary.
										var ndic: Dictionary = Dictionary ({source = src, action = val, params = data.params
										}) if data.has ("params") else Dictionary ({source = src, action = val});
										# Set value of the current referenced property to the method result.
										set_var (act, run_slot (ndic, object), src);
								# Sets value of the referenced property normaly.
								else: set_var (act, val, src);
							# Error message.
							else: _output ("Invalid syntax !", Message.ERROR);
						# The value of the value key is a dictionary.
						elif val is Dictionary:
							# The passed dictionary is a keyword supported by this method.
							if val.has ("action"): set_var (act, run_slot (val, object), src);
							# Set value of the referenced property normaly.
							else: set_var (act, val, src);
						# Set value of the referenced property normaly.
						else: set_var (act, val, src);
					# Returns the final value from the referenced property.
					return get_var (act, src);
				# The action is a method.
				else:
					# Checks parameters key existance.
					var params: Array = (Array (data.params) if is_array (data.params) else Array ([data.params])) if data.has ("params") else Array ([]);
					# Checks whether there are some specials values.
					for t in params.size ():
						# If the current parameter call specials treatments.
						if params [t] is String && len (params [t]) > 0 && params [t].lstrip (' ').begins_with ('?'):
							# Corrects the current paramerter syntax.
							var cur_val = params [t].split ('?'); cur_val = cur_val [1] if !cur_val [1].empty () else '';
							# Generates a dictionary to this parameter.
							params [t] = run_slot (Dictionary ({source = object.get_path (), action = cur_val}), object);
						# If the current parameter is a dictionary.
						elif params [t] is Dictionary && params [t].has ("action"): params [t] = run_slot (params [t], object);
					# Calls the given method.
					return invoke (act.split ("()") [0], params, src);
			# Error message.
			else: _output ("Invalid syntax !", Message.ERROR);
		# Error message.
		else: _output ("Missing action.", Message.ERROR); return null;

"""
	@Description: Runs severals slots pre-configured by the developper from an array of dictionary.
	@Parameters:
		Dictionary | Array data: Contains all configurations about the targets slots. The dictionaries of this array support
			some keys that have been already describe on "run_slot ()" method definition. All elements of this array
			must be some dictionaries. It's very important to know that.
		Node object: Which knot will be considered to make the differents operations ?
		float delay: What is the timeout before running slots ?
"""
static func run_slots (data, object: Node, delay: float = 0.0) -> void:
	# Waiting for user delay.
	if !Engine.editor_hint && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
	# Converting data into an array and runs all passed actions..
	data = Array ([data]) if not is_array (data) else Array (data); for datum in data: if datum is Dictionary: run_slot (datum, object);

"""
	@Description: Returns the joystick category from his name.
	@Parameters:
		String jname: Contains the target gamepad name.
		Node object: Which knot will be considered to make the differents operations ?
		String path: Contains the path to additional gamepads list file. You can find this file at "res://addons/mega_ssets/nodes/base/mega_assets/gamepads.cfg".
			Use this parameter whether you want to add some gamepads with their category. To add some gamepads, use this nomenclature:
			[gamepads]
			ControllerName1 = ControllerCategory1 (Playstation, Xbox, Nitendo, etc...)
			ControllerName2 = ControllerName2 (Playstation, Xbox, Nitendo, etc...)
			...
			ControllerNameN = ControllerCategoryN (Playstation, Xbox, Nitendo, etc...)
"""
static func get_joy_category (jname: String, object: Node, path: String = "res://nodes/base/mega_assets/gamepads.cfg", _nme = null, _data = null) -> String:
	# Collect informations about detected controller.
	jname = (jname if _nme == null else _nme).to_lower (); _data = _check_joy_keys (jname) if _data == null else _data;
	# The detected controller is a Playstation gamepad.
	if _data [0] || _data [1] || _data [2] || _data [3] || _data [4] || _data [5] || _data [6]: return "PlayStation Controller";
	# The detected controller is an Xbox gamepad.
	elif _data [10] || _data [11] || _data [12] || _data [13]: return "Xbox Controller";
	# The detected controller is a Nintendo gamepad.
	elif _data [14] || _data [15] || _data [18]: return "Nintendo Controller";
	# The detected controller is a Wii gamepad.
	elif _data [16] || _data [22]: return "Wii Controller";
	# The detected controller is a Sega gamepad.
	elif _data [17] || _data [20] || _data [21]: return "Sega Controller";
	# The detected controller is a Neogeo gamepad.
	elif _data [19]: return "Neogeo Controller";
	# A path has been specified.
	elif not path.lstrip (' ').rstrip (' ').empty ():
		# Loads gamepads configurations.
		var configs: Dictionary = load_config_file (path, object);
		# Some gamepads has been specified.
		if configs.has ("gamepads") && configs.gamepads is Dictionary:
			# Check others gamepads.
			for ky in configs.gamepads:
				# Convert the current key into a string format.
				var key: String = str (ky).to_lower ().lstrip ('_').rstrip ('_');
				# '_' characters have been detected.
				if key.find ('_') != -1:
					# Getting keywords.
					for keyword in key.split ('_'): if jname.find (keyword) != -1: return get_joy_category ('', object, '', configs.gamepads [ky], null);
				# The current joystick name is inside of the given gamepad name.
				elif jname.find (key) != -1: return get_joy_category ('', object, '', configs.gamepads [ky], null);
			# Unknown gamepad.
			return "Unknown Controller";
		# Unknown gamepad.
		else: return "Unknown Controller";
	# Unknown controller.
	else: return "Unknown Controller";

"""
	@Description: Returns all detected gamepads names.
	@Parameters:
		int limit: How many gamepads would you want to detect ?
"""
static func get_detected_controllers_names (limit: int = -1):
	# No limit is given.
	if limit < 0: return get_connected_controllers_names ();
	# No gamepads will be returned.
	elif limit == 0: return null;
	# Some limits have been found.
	else:
		# Getting connected controllers names.
		var gamepads: PoolStringArray = get_connected_controllers_names (); var results: PoolStringArray = PoolStringArray ([]);
		# The given limit is less that the gamepads size.
		if limit <= gamepads.size (): for p in range (0, limit, 1): results.append (gamepads [p]);
		# Otherwise.
		else: for p in range (0, gamepads.size (), 1): results.append (gamepads [p]);
		# Return the final result.
		if results.size () <= 0: return null; elif results.size () == 1: return results [0]; else: return results;

"""
	@Description: Returns the corresponding key name of an input event from this controller. This feature doesn't work at any time.
	@Parameters:
		InputEvent key_event: Contains an input event key.
		Node object: Which knot will be considered to make the differents operations ?
		int device: Which joystick device listen ? (Only on joystick controller).
		String path: Contains the path pointing to the controller configuration file (.cfg) not recognized by this method. To edit this
			file, you must follow the following nomenclature:
			[gamepads]
			ControllerName1 = ControllerCategory1 (Playstation, Xbox, Nitendo, etc...)
			ControllerName2 = ControllerName2 (Playstation, Xbox, Nitendo, etc...)
			...
			ControllerNameN = ControllerCategoryN (Playstation, Xbox, Nitendo, etc...)
"""
static func get_input_key_translation (key_event: InputEvent, object: Node, device: int = 0, path: String = "res://nodes/base/mega_assets/gamepads.cfg") -> String:
	# For the keyboard controller.
	if key_event is InputEventKey: return OS.get_scancode_string (key_event.scancode);
	# For the mouse controller.
	elif key_event is InputEventMouse:
		# For mouse buttons.
		if key_event is InputEventMouseButton:
			# Check mouse button.
			if key_event.button_index == BUTTON_LEFT: return "Mouse Button Left"; elif key_event.button_index == BUTTON_RIGHT: return "Mouse Button Right";
			elif key_event.button_index == BUTTON_MIDDLE || key_event.button_mask == BUTTON_MASK_MIDDLE: return "Mouse Button Middle";
			elif key_event.button_index == BUTTON_WHEEL_UP: return "Mouse Wheel Up"; elif key_event.button_index == BUTTON_WHEEL_DOWN: return "Mouse Wheel Down";
			elif key_event.button_index == BUTTON_WHEEL_LEFT: return "Mouse Wheel Left"; elif key_event.button_index == BUTTON_WHEEL_RIGHT: return "Mouse Wheel Right";
			elif key_event.button_index == BUTTON_XBUTTON1 || key_event.button_mask == BUTTON_MASK_XBUTTON1: return "Mouse XButton 1";
			elif key_event.button_index == BUTTON_XBUTTON2 || key_event.button_mask == BUTTON_MASK_XBUTTON2: return "Mouse XButton 2";
		# For mouse motions.
		elif key_event is InputEventMouseMotion:
			# Check mouse axis.
			if key_event.relative [0] > 0.0: return "+MouseX"; elif key_event.relative [0] < 0.0: return "-MouseX";
			if key_event.relative [1] > 0.0: return "+MouseY"; elif key_event.relative [1] < 0.0: return "-MouseY";
	# For joystick buttons.
	elif key_event is InputEventJoypadButton:
		# Collect informations about detected controller.
		var jn: String = Input.get_joy_name (device).to_lower (); var data: Array = _check_joy_keys (jn);
		var cn: String = Input.get_joy_button_string (key_event.button_index if key_event.button_index < JOY_BUTTON_MAX else 0);
		cn = "Max" if key_event.button_index == JOY_BUTTON_MAX else cn; var cat: String = get_joy_category (jn, object, path, null, data);
		# The detected controller is a Playstation gamepad.
		if cat == "PlayStation Controller":
			# Check the button name.
			if cn == "L3" && data [7] || cn == "L2" && data [7]: return "Beat The Drum Left";
			elif cn == "R3" && data [7] || cn == "R2" && data [7]: return "Beat The Drum Right";
			elif cn == "L3" && data [8] || cn == "L2" && data [8]: return "Beat The Drum Left";
			elif cn == "R3" && data [8] || cn == "R2" && data [8]: return "Beat The Drum Right";
			elif cn == "Start" && data [9]: return "Options"; elif cn == "Face Button Top" && data [0]: return '1';
			elif cn == "Face Button Right" && data [0]: return '2'; elif cn == "Face Button Bottom" && data [0]: return '3';
			elif cn == "Face Button Left" && data [0]: return '4'; elif cn == "Face Button Right": return 'O';
			elif cn == "Select" && data [9]: return "Share"; elif cn == "Face Button Bottom": return 'X';
			elif cn == "Face Button Top": return "Triange"; elif cn == 'L': return "L1"; elif cn == 'R': return "R1";
			elif cn == "Face Button Left": return "Square"; else: return cn;
		# The detected controller is an Xbox gamepad.
		elif cat == "Xbox Controller":
			# Check the button name.
			if cn == "Select" && data [12]: return "View"; elif cn == "Start" && data [12]: return "Menu";
			elif cn == "Select" && data [11]: return "Back"; elif cn == "L2" || key_event.get ("axis") == JOY_AXIS_6: return "LT";
			elif cn == 'L': return "LB"; elif cn == 'R': return "RB"; elif cn == "R2" || key_event.get ("axis") == JOY_AXIS_7: return "RT";
			elif cn == "Face Button Top": return 'Y'; elif cn == "Face Button Bottom": return 'A'; elif cn == "Select": return "Back";
			elif cn == "Face Button Left": return 'X'; elif cn == "Face Button Right": return 'B'; else: return cn;
		# The detected controller is a Nintendo, Wii, Sega, Neogeo gamepad.
		elif cat == "Nintendo Controller" || cat == "Wii Controller" || cat == "Sega Controller" || cat == "Neogeo Controller":
			if cn == "Face Button Bottom" && data [22]: return '2'; elif cn == "Face Button Left" && data [22]: return '1';
			elif cn == 'L' && data [22]: return 'C'; elif cn == "L2" && data [22] || key_event.get ("axis") == JOY_AXIS_6 && data [22]: return "Z+";
			elif cn == "Face Button Top" && data [18]: return 'C'; elif cn == "Face Button Right" && data [18]: return 'D';
			elif cn == "Face Button Left" && data [18]: return 'A'; elif cn == "Select" && data [18]: return "Select";
			elif cn == "Start" && data [18]: return "Start"; elif cn == 'R' && data [19]: return 'C';
			elif cn == "Select" && data [19]: return "Select"; elif cn == "Start" && data [19]: return "Start";
			elif cn == 'L' && data [20]: return 'Z'; elif cn == "Select" && data [20]: return "Mode";
			elif cn == 'R' && data [20]: return 'C'; elif cn == "Start" && data [20]: return "Start";
			elif cn == "L3" && data [7] || cn == "L2" && data [7]: return "Beat The Drum Left";
			elif cn == "R3" && data [7] || cn == "R2" && data [7]: return "Beat The Drum Right";
			elif cn == "L3" && data [8] || cn == "L2" && data [8]: return "Beat The Drum Left";
			elif cn == "R3" && data [8] || cn == "R2" && data [8]: return "Beat The Drum Right";
			elif cn == "Face Button Top": return 'X'; elif cn == "Face Button Bottom": return 'B';
			elif cn == "Face Button Left": return 'Y'; elif cn == "Face Button Right": return 'A';
			elif cn == "L2" || key_event.get ("axis") == JOY_AXIS_6: return "ZL";
			elif cn == "R2" || key_event.get ("axis") == JOY_AXIS_7: return "ZR";
			elif cn == "Select": return "---"; elif cn == "Start": return "-|-"; else: return cn;
		# Unknown gamepad.
		else: return cn;
	# For joystick motions.
	elif key_event is InputEventJoypadMotion:
		# Collect informations about detected controller.
		var ax: float = get_filtered_joy_axis (Input.get_joy_axis (device, key_event.axis));
		var axn: String = ("-Axis" + str (key_event.axis)) if ax < 0.0 else ("+Axis" + str (key_event.axis)); axn = '' if ax == 0.0 else axn;
		# Check controller axis.
		if axn == "-Axis0" && ax < 0.0: return "-Left Analog X"; elif axn == "+Axis0" && ax > 0.0: return "+Left Analog X";
		elif axn == "-Axis1" && ax < 0.0: return "-Left Analog Y"; elif axn == "+Axis1" && ax > 0.0: return "+Left Analog Y";
		elif axn == "-Axis2" && ax < 0.0: return "-Right Analog X"; elif axn == "+Axis2" && ax > 0.0: return "+Right Analog X";
		elif axn == "-Axis3" && ax < 0.0: return "-Right Analog Y"; elif axn == "+Axis3" && ax > 0.0: return "+Right Analog Y";
		elif axn == "-Axis6" && ax < 0.0: return "-Left Trigger"; elif axn == "+Axis6" && ax < 0.0: return "+Left Trigger";
		elif axn == "-Axis7" && ax < 0.0: return "-Right Trigger"; elif axn == "+Axis7" && ax < 0.0: return "+Right Trigger";
		else: return "Null";
	# Unknown input.
	return "Null";

"""
	@Description: Determinates whether an input event is a button.
	@Parameters:
		InputEvent key_event: Contains an input event key.
"""
static func is_button (key_event: InputEvent) -> bool: return key_event is InputEventKey || key_event is InputEventMouseButton || key_event is InputEventJoypadButton;

"""
	@Description: Determinates whether an input event is an axis.
	@Parameters:
		InputEvent key_event: Contains an input event key.
"""
static func is_axis (key_event: InputEvent) -> bool: return key_event is InputEventMouseMotion || key_event is InputEventJoypadMotion;

"""
	@Description: Returns a filtered axis of a joystick axis.
	@Parameters:
		float axis: Contains a joystick axis value.
"""
static func get_filtered_joy_axis (axis: float) -> float:
	# Convert the real basic axis into string format.
	var asx = str (axis);
	# Find whether a comma and full stop.
	if asx.find ('.') != -1: asx = asx.split ('.'); elif asx.find (',') != -1: asx = asx.split (',');
	# Filtering the parsed axis.
	asx = (asx [0] + '.' + asx [1] [0]) if asx is PoolStringArray else asx; asx = asx as float;
	# Return the filtered axis value.
	return abs (asx) if asx == 0.0 else asx;

"""
	@Description: Determinates whether an input event is pressed.
	@Parameters:
		InputEvent key_event: Contains an input event key.
		int device: Which joystick device listen ? (Only on joystick controller).
"""
static func is_key_or_axis_pressed (key_event: InputEvent, device: int = 0) -> bool:
	# For the keyboard buttons.
	if key_event is InputEventKey: return Input.is_key_pressed (key_event.scancode);
	# For mouse buttons.
	elif key_event is InputEventMouseButton: return Input.is_mouse_button_pressed (key_event.button_index);
	# For joystick butttons.
	elif key_event is InputEventJoypadButton: return Input.is_joy_button_pressed (device, key_event.button_index);
	# For mouse axis.
	elif key_event is InputEventMouseMotion && key_event.relative != Vector2.ZERO: return true;
	# For joystick axis.
	elif key_event is InputEventJoypadMotion && get_filtered_joy_axis (key_event.axis_value) != 0.0: return true;
	# No input action detected.
	else: return false;

"""@Description: Returns all connected joypads to the computer."""
static func get_connected_controllers_names () -> PoolStringArray:
	# Contains all connected controllers.
	var conts: PoolStringArray = PoolStringArray ([]); conts.append ("Mouse"); conts.append ("Keyboard");
	# Get all connected joypads ids.
	for joy_id in Input.get_connected_joypads (): conts.append (Input.get_joy_name (joy_id)); return conts;

"""
	@Description: Returns the corresponding keycode of a pressed key as string format.
	@Parameters:
		InputEvent key_event: Contains an input event key.
		int device: Which joystick device listen ? (Only on joystick controller).
		bool mask: Do you want to get mouse keycode from a mask ? (Only on mouse controller).
"""
static func get_keycode_string (key_event: InputEvent, device: int = 0, mask: bool = false) -> String:
	# For the keyboard controller.
	if key_event is InputEventKey: return OS.get_scancode_string (key_event.scancode);
	# For the mouse controller.
	elif key_event is InputEventMouse:
		# For mouse buttons.
		if key_event is InputEventMouseButton:
			# The key is the mouse wheel.
			if key_event.button_index == BUTTON_WHEEL_UP: return "-ScrollY"; elif key_event.button_index == BUTTON_WHEEL_DOWN: return "+ScrollY";
			elif key_event.button_index == BUTTON_WHEEL_LEFT: return "-ScrollX"; elif key_event.button_index == BUTTON_WHEEL_RIGHT: return "+ScrollX";
			else: return ("Mouse" + str (key_event.button_index)) if !mask else ("Mouse" + str (key_event.button_mask));
		# For mouse motions.
		elif key_event is InputEventMouseMotion:
			# Check mouse axis.
			if key_event.relative.x > 0.0 and key_event.relative.y > 0.0: return "+MouseX++MouseY";
			elif key_event.relative.x < 0.0 and key_event.relative.y < 0.0: return "-MouseX+-MouseY";
			elif key_event.relative.x < 0.0 and key_event.relative.y > 0.0: return "-MouseX++MouseY";
			elif key_event.relative.x > 0.0 and key_event.relative.y < 0.0: return "+MouseX+-MouseY";
			elif key_event.relative.x < 0.0: return "-MouseX"; elif key_event.relative.x > 0.0: return "+MouseX";
			elif key_event.relative.y < 0.0: return "-MouseY"; elif key_event.relative.y > 0.0: return "+MouseY";
			elif key_event.relative.x == 0.0: return "MouseX"; elif key_event.relative.y == 0.0: return "MouseY";
			else: return "MouseX+MouseY";
	# For joystick buttons.
	elif key_event is InputEventJoypadButton: return ("Joy" + str (key_event.button_index));
	# For joystick motions.
	elif key_event is InputEventJoypadMotion:
		# Collect informations about detected controller.
		var ax: float = get_filtered_joy_axis (Input.get_joy_axis (device, key_event.axis));
		var axn: String = ("-Axis" + str (key_event.axis)) if ax < 0.0 else (("+Axis" + str (key_event.axis)) if ax > 0.0 else ("Axis" + str (key_event.axis)));
		# Return the final result.
		return axn;
	# Return a fake value.
	return "Null";

"""
	@Description: Moves a kinematic body from the root motion transform of a skeleton.
	@Parameters:
		Node | String | NodePath anim: Contains an AnimationTree node instance.
		Node | String | NodePath node: Contains a KinematicBody node instance.
		float delta: Contains the elapsed time since the previous frame.
		float gravity: Contains the gravity value.
		float delay: What is the timeout before each update ?
"""
func apply_root_motion (anim, node, delta, gravity: float = 9.8, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !self.is_game_initialised (): yield (self.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Get the real AnimationTree.
	anim = self.get_node_or_null (anim) if anim is NodePath or anim is String else anim;
	# Get the real KenematicBdy.
	node = self.get_node_or_null (node) if node is NodePath or node is String else node;
	# The found node is an animation tree.
	if anim is AnimationTree:
		# The found node is a kinematic body.
		if node is KinematicBody:
			# Move the target node with the given skeleton bone transform.
			__cash__.velocity.y += (gravity * delta); var transform_tmp: Transform = node.get_global_transform ();
			# Get bone root motion transform.
			transform_tmp.origin *= Vector3.ZERO; var root_motion: Transform = anim.get_root_motion_transform ();
			# Convert the root motion to global transform.
			transform_tmp *= root_motion; var velocity_tmp: Vector3 = (transform_tmp.origin / delta);
			# Move the target node.
			velocity_tmp.y = self.__cash__.velocity.y; __cash__.velocity = node.move_and_slide (-velocity_tmp, Vector3.UP);
		# Error message.
		else: self._output ("The given node must be a KinematicBody.", Message.ERROR);
	# Error message.
	else: self._output ("The given node must be an AnimationTree.", Message.ERROR);

"""
	@Description: Apply a camera effect with some ajustments. This effects are provided by the framework.
	@Parameters:
		String | NodePath pvt: Contains the privot of effect. (Only on Sprite and TextureRect).
		int eft: What is the effect that will be applyed ?
		Node obj: Which knot will be considered to make the differents operations ?
		int lyt: Do you want to put a layout to your effect ? The possibles values are:
			MegaAssets.Disposal.NONE or 0: No layout will be applyed.
			MegaAssets.Disposal.CENTER or 1: Center effect.
			MegaAssets.Disposal.TOP or 2: Move effect to screen top.
			MegaAssets.Disposal.RIGHT or 3: Move effect to screen right.
			MegaAssets.Disposal.BOTTOM or 4: Move effect to screen bottom.
			MegaAssets.Disposal.LEFT or 5: Move effect to screen left.
		int fus: Do you want to resize your effect ? The possibles values are:
			MegaAssets.FullMonitor.NONE or 0: No resize will be applyed.
			MegaAssets.FullMonitor.HORIZONTAL or 1: Horizontal resize.
			MegaAssets.FullMonitor.VERTICAL or 2: Vertical resize.
			MegaAssets.FullMonitor.BOTH or 3: Horizontal and vertical resize.
		float delay: What is the timeout before apply the target effect ?
"""
static func apply_camera_effect (pvt: NodePath, eft: int, obj: Node, lyt: int = 0, fus: int = 0, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (obj.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (obj.get_tree ().create_timer (delay), "timeout");
	# Get the real node of privot.
	var privot = obj.get_node_or_null (pvt);
	# Check privot type.
	if privot is TextureRect || privot is Sprite:
		# Contains the game viewport.
		var app: Viewport = obj.get_viewport ();
		# The effect targets an object of control node.
		if privot is TextureRect:
			# For horizontal fullscreen.
			if fus == FullMonitor.HORIZONTAL:
				privot.rect_position.x = 0; privot.rect_size.x = app.size.x;
			# For vertical fullscreen.
			elif fus == FullMonitor.VERTICAL:
				privot.rect_position.y = 0; privot.rect_size.y = app.size.y;
			# For vertical and horizontal fullscreen.
			elif fus >= FullMonitor.BOTH:
				privot.rect_position = Vector2.ZERO; privot.rect_size = app.size;
			# Layout center.
			if lyt == Disposal.CENTER && privot.rect_size.x < app.size.x: privot.rect_position.x = ((app.size.x / 2) - (privot.rect_size.x / 2));
			if lyt == Disposal.CENTER && privot.rect_size.y < app.size.y: privot.rect_position.y = ((app.size.y / 2) - (privot.rect_size.y / 2));
			# Layout top.
			elif lyt == Disposal.TOP && privot.rect_size.y < app.size.y: privot.rect_position.y = 0;
			# Layout right.
			elif lyt == Disposal.RIGHT && privot.rect_size.x < app.size.x: privot.rect_position.x = (app.size.x - privot.rect_size.x);
			# Layout bottom.
			elif lyt == Disposal.BOTTOM && privot.rect_size.y < app.size.y: privot.rect_position.y = (app.size.y - privot.rect_size.y);
			# Layout left.
			elif lyt >= Disposal.LEFT && privot.rect_size.x < app.size.x: privot.rect_position.x = 0;
		# Otherwise.
		else:
			# Configure the passed sprite instance.
			if fus > FullMonitor.NONE || lyt > Disposal.NONE:
				privot.centered = true; privot.offset = Vector2.ZERO; privot.region_enabled = false;
			# For horizontal, vertical fullscreen.
			if fus == FullMonitor.HORIZONTAL: privot.scale.x = app.size.x; elif fus == FullMonitor.VERTICAL: privot.scale.y = app.size.y;
			# For vertical and horizontal fullscreen.
			elif fus >= FullMonitor.BOTH: privot.scale = Vector2 ((app.size.x / 63), (app.size.y / 63));
			# Layout center.
			if lyt == Disposal.CENTER: privot.position = Vector2 (((app.size.x / 2) - (privot.scale.x / 2)), ((app.size.y / 2) - (privot.scale.y / 2)));
			# Layout top.
			elif lyt == Disposal.TOP && privot.scale.y < app.size.y: privot.position.y = (privot.scale.y * 32);
			# Layout right.
			elif lyt == Disposal.RIGHT && privot.scale.x < app.size.x: privot.position.x = (app.size.x - (privot.scale.x * 32));
			# Layout bottom.
			elif lyt == Disposal.BOTTOM && privot.scale.y < app.size.y: privot.position.y = (app.size.y - (privot.scale.y * 32));
			# Layout left.
			elif lyt >= Disposal.LEFT && privot.scale.x < app.size.x: privot.position.x = (privot.scale.x * 32);
		# Contains an instance of an effect.
		var effect = null; var root_folders: String = "res://nodes/camera/camera_effects/";
		# Apply a default image.
		privot.texture = load (root_folders + "white.png");
		# Check given effect that will be loaded.
		if eft == CameraEffect.NONE:
			privot.material = null; return;
		elif eft == CameraEffect.SIMLE_BLUR: effect = load (root_folders + "simple_blur.shader");
		elif eft == CameraEffect.VIGNETTE: effect = load (root_folders + "vignette.shader");
		elif eft == CameraEffect.PIXELIZE: effect = load (root_folders + "pixelize.shader");
		elif eft == CameraEffect.WHIRL: effect = load (root_folders + "whirl.shader");
		elif eft == CameraEffect.SEPIA: effect = load (root_folders + "sepia.shader");
		elif eft == CameraEffect.NEGATIVE: effect = load (root_folders + "negative.shader");
		elif eft == CameraEffect.CONTRASTED: effect = load (root_folders + "contrasted.shader");
		elif eft == CameraEffect.NORMALIZED: effect = load (root_folders + "normalized.shader");
		elif eft == CameraEffect.BCS: effect = load (root_folders + "bcs.shader");
		elif eft == CameraEffect.MIRAGE: effect = load (root_folders + "mirage.shader");
		elif eft == CameraEffect.OLD_FILM: effect = load (root_folders + "old_film.shader");
		elif eft == CameraEffect.STATIC_CRT: effect = load (root_folders + "static_crt.shader");
		elif eft == CameraEffect.MOSAIC: effect = load (root_folders + "mosaic2d.shader");
		elif eft == CameraEffect.LCD: effect = load (root_folders + "lcd.shader");
		elif eft == CameraEffect.GAMEBOY: effect = load (root_folders + "gameboy_filter.shader");
		elif eft == CameraEffect.TONE_COMIC: effect = load (root_folders + "tone_comic.shader");
		elif eft == CameraEffect.INVERT: effect = load (root_folders + "invert.shader");
		elif eft == CameraEffect.TV: effect = load (root_folders + "tv.shader");
		elif eft == CameraEffect.VHS: effect = load (root_folders + "vhs.shader");
		elif eft == CameraEffect.VHS_GLITCH: effect = load (root_folders + "vhs_glitch.shader");
		elif eft == CameraEffect.VHS_PAUSE: effect = load (root_folders + "vhs_pause.shader");
		elif eft == CameraEffect.VHS_SIMPLE_GLITCH: effect = load (root_folders + "vhs_simple_glitch.shader");
		elif eft == CameraEffect.BW: effect = load (root_folders + "bw.shader");
		elif eft == CameraEffect.BETTER_CC: effect = load (root_folders + "better_cc.shader");
		elif eft == CameraEffect.COLOR_PRECISION: effect = load (root_folders + "color_precision.shader");
		elif eft == CameraEffect.GRAIN: effect = load (root_folders + "grain.shader");
		elif eft == CameraEffect.LENS_DISTORTION: effect = load (root_folders + "lens_distortion.shader");
		elif eft == CameraEffect.SHARPNESS: effect = load (root_folders + "sharpness.shader");
		elif eft == CameraEffect.SIMPLE_GRAIN: effect = load (root_folders + "simple_grain.shader");
		elif eft == CameraEffect.RANDOM_NOISE: effect = load (root_folders + "random_noise.shader");
		elif eft == CameraEffect.SCANLINES: effect = load (root_folders + "scanlines.shader");
		elif eft == CameraEffect.GLITCH: effect = load (root_folders + "glitch.shader");
		elif eft == CameraEffect.CRT_SCREEN: effect = load (root_folders + "crt_screen.shader");
		elif eft == CameraEffect.SIMPLE_CRT: effect = load (root_folders + "simple_crt.shader");
		elif eft == CameraEffect.SIMPLE_GLITCH: effect = load (root_folders + "simple_glitch.shader");
		elif eft == CameraEffect.CRT_LOTTES: effect = load (root_folders + "crt_lottes.shader");
		elif eft == CameraEffect.ABERRATION: effect = load (root_folders + "aberration.shader");
		elif eft == CameraEffect.ADVANCED_MOSIC: effect = load (root_folders + "advanced_mosic.shader");
		elif eft == CameraEffect.ANIMATED_NOISE: effect = load (root_folders + "animated_noise.shader");
		elif eft == CameraEffect.AVERAGE: effect = load (root_folders + "average.shader");
		elif eft == CameraEffect.BACKGROUND: effect = load (root_folders + "background.shader");
		elif eft == CameraEffect.BINARY_CONVERSION: effect = load (root_folders + "binary_conversion.shader");
		elif eft == CameraEffect.BINARY_DEFAULT_MIX: effect = load (root_folders + "binary_default_mix.shader");
		elif eft == CameraEffect.COLOR_BLINDNESS: effect = load (root_folders + "color_blindness.shader");
		elif eft == CameraEffect.DEFAULT: effect = load (root_folders + "default.shader");
		elif eft == CameraEffect.EDGE_DEFAULT_MIX: effect = load (root_folders + "edge_default_mix.shader");
		elif eft == CameraEffect.EDGE_MOTION_MIX: effect = load (root_folders + "edge_motion_mix.shader");
		elif eft == CameraEffect.EDGE_PREWITT: effect = load (root_folders + "edge_prewitt.shader");
		elif eft == CameraEffect.SIMPLE_EDGE: effect = load (root_folders + "edge_simple.shader");
		elif eft == CameraEffect.EDGE_SOBEL: effect = load (root_folders + "edge_sobel.shader");
		elif eft == CameraEffect.MONOCHROME: effect = load (root_folders + "monochrome.shader");
		elif eft == CameraEffect.MOTION: effect = load (root_folders + "motion.shader");
		else: effect = load (root_folders + "simple_mosic.shader");
		# Update object shader.
		var shader: ShaderMaterial = ShaderMaterial.new (); shader.shader = effect; privot.material = shader;
		# For vignette effect.
		if eft == CameraEffect.VIGNETTE: privot.material.set_shader_param ("vignette", load (root_folders + "vignette.png"));
		# For sepia effect.
		elif eft == CameraEffect.SEPIA: privot.material.set_shader_param ("base", Color.silver);
		# For old film effect.
		elif eft == CameraEffect.OLD_FILM:
			# Change base color to gray.
			privot.material.set_shader_param ("base", Color.gray);
			# Load film grain texture.
			privot.material.set_shader_param ("grain", load (root_folders + "filmgrain.png"));
			# Load vignette texture.
			privot.material.set_shader_param ("vignette", load (root_folders + "vignette.png"));
		# For lcd effect.
		elif eft == CameraEffect.LCD: privot.material.set_shader_param ("residual_image_tex", 0);
		# For grain effect.
		elif eft == CameraEffect.GRAIN: privot.material.set_shader_param ("screen_size", app.size);
	# Error message.
	else: _output ("The passed node must be an instance of Sprite or TextureRect.", Message.ERROR);

"""
	@Description: Apply occlusion culling process from a single camera. The target object(s) must have some instances
		of the following class types: KinematicBody, RigidBody, Area, StaticBody, SoftBody.
	@Parameters:
		Node | String | NodePath cam: Contains an instance of a Camera class.
		Array nodes: Contains all target bodies. These bodies will be affected by the occlusion.
		float delta: What is he time from the preview game frame ?
		float acy: Contains the occlusion accuracy.
		float scans: Contains the occlusion scans per second.
		float delay: What is the timeout before starting occlusion culling ?
"""
func apply_occlusion_culling (cam, nodes: Array, delta: float, acy: float = 1000.0, scans: float = 10.0, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !self.is_game_initialised (): yield (self.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Get the real camera node.
	cam = self.get_node_or_null (cam) if cam is String or cam is NodePath else cam;
	# Check camera value.
	if cam is Camera:
		# Contains the ray screen position values.
		var nums: Array = Array ([0.0, 0.0, 0.0]);
		# Check meshes value.
		if nodes.size () > 0:
			# Ajust occlusion culling number.
			nums [0] =  (1 / (acy / 20)); nums [1] = (1 / (acy / 50)); nums [2] = (acy * 0.05);
			# Whether the time before a rescaning is greater that a certains value.
			if self.__cash__.occ_data [1] > (1.0 / scans):
				# Disable all given meshes visibility.
				for body in nodes: body.set ("visible", false); __cash__.occ_data [0] [0] = 1.0;
				__cash__.occ_data [0] [1] = 1.0; var app: Viewport = self.get_viewport ();
				# Apply occlusion culling.
				while ((app.size.y * nums [1]) * self.__cash__.occ_data [0] [1]) < app.size.y:
					# Get impact point from camera to his target.
					var pt: Vector2 = Vector2 (((app.size.x * nums [0]) * self.__cash__.occ_data [0] [0]),\
						((app.size.y * nums [1]) * self.__cash__.occ_data [0] [1]));
					# Project ray at this point from camera.
					var pos: Vector3 = cam.project_ray_origin (pt); var far: Vector3 = (pos + cam.project_ray_normal (pt) * cam.far);
					# Get detected object by the occlusion.
					var obj: Dictionary = cam.get_world ().direct_space_state.intersect_ray (pos, far, [cam], true, true);
					# Whether the given object is defined.
					if !obj.empty () and nodes.has (obj.collider): obj.collider.set ("visible", true);
					# Increase ray position.
					__cash__.occ_data [0] [0] += 1;
					# Whether ray position is occlusion number.
					if self.__cash__.occ_data [0] [0] > nums [2]:
						# Updates ray position.
						__cash__.occ_data [0] [0] = 1.0; __cash__.occ_data [0] [1] += 1;
				# Reset the time before rescaning.
				__cash__.occ_data [1] = 0.0;
			# Adapte the time before rescaning to delta.
			else: __cash__.occ_data [1] += delta;
	# Error message.
	else: self._output ("Missing camera !", Message.ERROR);

"""
	@Description: Determinates whether a value is inside of the given range.
	@Parameters:
		float value: Contains a value.
		float minimum: Contains the minimum value.
		float maximum: Contains the maximum value.
"""
static func is_range (value: float, minimum: float, maximum: float) -> bool: return value >= minimum && value <= maximum;

"""
	@Description: Apply a stardard effect provided by the framework.
	@Parameters:
		String | NodePath pvt: Contains the privot of effect.
		int eft: What is the effect that will be applyed ?
		Node obj: Which knot will be considered to make the differents operations ?
		bool geo: Do you want to affect geometry override material property ?
		bool next: Do you want to affect "next_pass" property to add more effect to the same object ?
		int idx: Which materal affected ? (Only whether geo parameters is set to false).
		float delay: What is the timeout before apply the target effect ?
"""
static func apply_std_effect (pvt: NodePath, eft, obj: Node, geo: bool = true, next: bool = false, idx: int = 0, delay: float = 0.0, _nxt = null) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (obj.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (obj.get_tree ().create_timer (delay), "timeout");
	# Get the real privot node instance.
	var privot = obj.get_node_or_null (pvt);
	# Check privot value.
	if privot is Node2D || privot is GeometryInstance || privot is Control:
		# Check privot type.
		if privot is Node2D && is_range (eft, 44, 72): _output ("Can't assign 3D effect to a Node2D type.", Message.ERROR);
		elif privot is Control && is_range (eft, 44, 72):  _output ("Can't assign 3D effect to a Control type.", Message.ERROR);
		elif privot is GeometryInstance && is_range (eft, 1, 43): _output ("Can't assign 2D effect to a GeometryInstance type.", Message.ERROR);
		elif privot is MeshInstance && !index_validation (idx, privot.get_surface_material_count ()): _output ("Material index is out of range.", Message.ERROR);
		# No errors detected.
		else:
			# Contains an instance of an effect.
			var effect = null; var root_folders: String = "res://nodes/general/standard_effects/";
			# Check given effect that will be loaded.
			if eft <= StandardEffect.NONE:
				if privot is Node2D or privot is Control: privot.material = null;
				elif privot is MeshInstance && !geo: privot.set_surface_material (idx, null);
				else: privot.material_override = null; return;
			elif eft == StandardEffect.BAKED_SPRITE_GLOW2D: effect = load (root_folders + "baked_sprite_glow2d.shader");
			elif eft == StandardEffect.BILINEAR_FILTERING2D: effect = load (root_folders + "bilinear_filtering2d.shader");
			elif eft == StandardEffect.BILLBOARD2D: effect = load (root_folders + "billboard2d.shader");
			elif eft == StandardEffect.BLUR2D: effect = load (root_folders + "blur2d.shader");
			elif eft == StandardEffect.CHROMATIC_ABERATION2D: effect = load (root_folders + "chromatic_aberation2d.shader");
			elif eft == StandardEffect.CLOUD2D: effect = load (root_folders + "cloud2d.shader");
			elif eft == StandardEffect.COMPOSE2D: effect = load (root_folders + "compose2d.shader");
			elif eft == StandardEffect.CROSSHAIR2D: effect = load (root_folders + "crosshair2d.shader");
			elif eft == StandardEffect.DISSOLVE2D: effect = load (root_folders + "dissolve2d.shader");
			elif eft == StandardEffect.DISTORTION2D: effect = load (root_folders + "distortion2d.shader");
			elif eft == StandardEffect.FADE2D: effect = load (root_folders + "fade2d.shader");
			elif eft == StandardEffect.FLAT_OUTLINE2D: effect = load (root_folders + "flat_outline2d.shader");
			elif eft == StandardEffect.GAUSSIAN_BLUR2D: effect = load (root_folders + "gaussian_blur2d.shader");
			elif eft == StandardEffect.GAUSSIAN_BLUR2D_OPTIMIZED: effect = load (root_folders + "gaussian_blur_optimized2d.shader");
			elif eft == StandardEffect.GRADIENT2D: effect = load (root_folders + "gradient2d.shader");
			elif eft == StandardEffect.GRADIENT_SHIFT2D: effect = load (root_folders + "gradient_shift2d.shader");
			elif eft == StandardEffect.GRAYSCALE2D: effect = load (root_folders + "grayscale2d.shader");
			elif eft == StandardEffect.INLINE2D: effect = load (root_folders + "inline2d.shader");
			elif eft == StandardEffect.INOUTLINE2D: effect = load (root_folders + "inoutline2d.shader");
			elif eft == StandardEffect.INVERT2D: effect = load (root_folders + "invert2d.shader");
			elif eft == StandardEffect.NEGATIVE2D: effect = load (root_folders + "negative2d.shader");
			elif eft == StandardEffect.OUTLINE2D: effect = load (root_folders + "outline2d.shader");
			elif eft == StandardEffect.PIXELIZE2D: effect = load (root_folders + "pixelize2d.shader");
			elif eft == StandardEffect.PIXEL_OUTLINE2D: effect = load (root_folders + "pixel_outline2d.shader");
			elif eft == StandardEffect.POINTILISM2D: effect = load (root_folders + "pointilism2d.shader");
			elif eft == StandardEffect.PSYCHADELIC2D: effect = load (root_folders + "psychadelic2d.shader");
			elif eft == StandardEffect.REFLECTION2D: effect = load (root_folders + "reflection2d.shader");
			elif eft == StandardEffect.SEPIA2D: effect = load (root_folders + "sepia2d.shader");
			elif eft == StandardEffect.SHADOW2D: effect = load (root_folders + "shadow2d.shader");
			elif eft == StandardEffect.SHINY2D: effect = load (root_folders + "shiny2d.shader");
			elif eft == StandardEffect.SHOCKWAVE2D: effect = load (root_folders + "shockwave2d.shader");
			elif eft == StandardEffect.SIMPLE_DISSOLVE2D: effect = load (root_folders + "simple_dissolve2d.shader");
			elif eft == StandardEffect.SOBEL_EDGE2D: effect = load (root_folders + "sobel_edge2d.shader");
			elif eft == StandardEffect.STACKED2D: effect = load (root_folders + "stacked2d.shader");
			elif eft == StandardEffect.SWIRL2D: effect = load (root_folders + "swirl2d.shader");
			elif eft == StandardEffect.VIGNETTE2D: effect = load (root_folders + "vignette2d.shader");
			elif eft == StandardEffect.WATER2D: effect = load (root_folders + "water2d.shader");
			elif eft == StandardEffect.XRAY_MASK2D: effect = load (root_folders + "xray_mask2d.shader");
			elif eft == StandardEffect.ZOOM_BLUR2D: effect = load (root_folders + "zoom_blur2d.shader");
			elif eft == StandardEffect.XBRZ2D: effect = load (root_folders + "xBRZ2d.shader");
			elif eft == StandardEffect.SIMPLE_FIRE2D: effect = load (root_folders + "simple_fire2d.shader");
			elif eft == StandardEffect.OMNISCALE2D: effect = load (root_folders + "omniscale2d.shader");
			elif eft == StandardEffect.EASY_BLEND2D: effect = load (root_folders + "easy_blend2d.shader");
			elif eft == StandardEffect.AVANCED_TOON3D: effect = load (root_folders + "advanced_toon3d.shader");
			elif eft == StandardEffect.CEL3D: effect = load (root_folders + "cel3d.shader");
			elif eft == StandardEffect.CLOUD3D: effect = load (root_folders + "cloud3d.shader");
			elif eft == StandardEffect.COLOR_BLENDED3D: effect = load (root_folders + "color_blended3d.shader");
			elif eft == StandardEffect.CRISTAL3D: effect = load (root_folders + "cristal3d.shader");
			elif eft == StandardEffect.CURVATURE3D: effect = load (root_folders + "curvature3d.shader");
			elif eft == StandardEffect.DISSOLVE3D: effect = load (root_folders + "dissolve3d.shader");
			elif eft == StandardEffect.FLEXIBLE_TOON3D: effect = load (root_folders + "flexible_toon3d.shader");
			elif eft == StandardEffect.FORCE_FIELD3D: effect = load (root_folders + "force_field3d.shader");
			elif eft == StandardEffect.GRADIENT3D: effect = load (root_folders + "gradient3d.shader");
			elif eft == StandardEffect.MOSAIC3D: effect = load (root_folders + "mosaic3d.shader");
			elif eft == StandardEffect.OUTLINE3D: effect = load (root_folders + "outline3d.shader");
			elif eft == StandardEffect.OVERDRAW3D: effect = load (root_folders + "overdraw3d.shader");
			elif eft == StandardEffect.PLANET_ATMOSPHERE3D: effect = load (root_folders + "planet_atmosphere3d.shader");
			elif eft == StandardEffect.PSX_LIT3D: effect = load (root_folders + "psx_lit3d.shader");
			elif eft == StandardEffect.PULSE_GLOW3D: effect = load (root_folders + "pulse_glow3d.shader");
			elif eft == StandardEffect.REFRACTION3D: effect = load (root_folders + "refraction3d.shader");
			elif eft == StandardEffect.RIM3D: effect = load (root_folders + "rim3d.shader");
			elif eft == StandardEffect.SHOCKWAVE3D: effect = load (root_folders + "shockwave3d.shader");
			elif eft == StandardEffect.SIMPLE_FORCE_FIELD3D: effect = load (root_folders + "simple_force_field3d.shader");
			elif eft == StandardEffect.STYLIZED_LIQUID: effect = load (root_folders + "stylized_liquid3d.shader");
			elif eft == StandardEffect.WIND3D: effect = load (root_folders + "wind3d.shader");
			elif eft == StandardEffect.XRAY_GLOW3D: effect = load (root_folders + "xray_glow3d.shader");
			elif eft == StandardEffect.DEBANDING_MATERIAL3D: effect = load (root_folders + "debanding_material3d.shader");
			elif eft == StandardEffect.ADVANCED_DECAL3D: effect = load (root_folders + "advanced_decal3d.shader");
			elif eft == StandardEffect.SIMPLE_DECAL3D: effect = load (root_folders + "simple_decal3d.shader");
			elif eft == StandardEffect.SIMPLE_FIRE3D: effect = load (root_folders + "simple_fire3d.shader");
			elif eft == StandardEffect.LIGHT_RAYS3D: effect = load (root_folders + "light_rays3d.shader");
			else: effect = load (root_folders + "lens_flare3d.shader");
			# Update object shader.
			var shader: ShaderMaterial = ShaderMaterial.new (); shader.shader = effect;
			# For dissolve 2d effect.
			if eft == StandardEffect.DISSOLVE2D: shader.set_shader_param ("noise_texture", load (root_folders + "fade_mask.png"));
			# For fade 2d effect.
			elif eft == StandardEffect.FADE2D: shader.set_shader_param ("fade_mask", load (root_folders + "fade_mask_soft.png"));
			# For simple dissolve 2d effect.
			elif eft == StandardEffect.SIMPLE_DISSOLVE2D: shader.set_shader_param ("dissolve_texture", load (root_folders + "fade_mask_soft.png"));
			# For dissolve 3d effect.
			elif eft == StandardEffect.DISSOLVE3D: shader.set_shader_param ("dissolve_texture", load (root_folders + "fade_mask_low_resolution.png"));
			# For force field 3d effect.
			elif eft == StandardEffect.FORCE_FIELD3D: shader.set_shader_param ("pattern_texture", load (root_folders + "hexagon_grid.png"));
			# For simple force field 3d effect.
			elif eft == StandardEffect.SIMPLE_FORCE_FIELD3D: shader.set_shader_param ("hex_tex", load (root_folders + "hexes.png"));
			# For lens flare 3d effect.
			elif eft == StandardEffect.LENS_FLARE3D: shader.set_shader_param ("lens_dirt", load (root_folders + "lens_dirt_default.jpeg"));
			# For next pass effect.
			if next:
				# Update nxt ref value.
				_nxt = ((privot.material if privot is Node2D || privot is Control else (privot.get_surface_material (idx)\
					if privot is MeshInstance and !geo else privot.material_override)) if _nxt == null else _nxt);
				# Check material value of the given object.
				if _nxt == null:
					# For a mesh instance.
					if privot is MeshInstance and !geo: privot.set_surface_material (idx, shader);
					# For a control or node2d.
					elif privot is Node2D or privot is Control: privot.material = shader;
					# For geometry instance.
					else: privot.material_override = shader;
				# Otherwise.
				else:
					# The next of the given material is null.
					if _nxt.next_pass == null: _nxt.next_pass = shader;
					# Otherwise.
					else: apply_std_effect (pvt, eft, obj, geo, next, idx, -1.0, _nxt.next_pass);
			# Otherwise.
			else:
				# For a mesh instance.
				if privot is MeshInstance and !geo: privot.set_surface_material (idx, shader);
				# For a control or node2d.
				elif privot is Node2D or privot is Control: privot.material = shader;
				# For geometry instance.
				else: privot.material_override = shader;
	# Error message.
	else: _output ("The object type instance isn't supported on this method.", Message.ERROR);

"""
	@Description: Returns the bone transform from a target position. This method uses look at function to follow the given object.
	@Parameters:
		String | NodePath skn: Contains a skeleton node.
		String bme: What is the bone id to targeted.
		String | NodePath tar: What is the target of the given bone (Only on Spatial node).
		Node obj: Which knot will be considered to make the differents operations ?
		int dir: Which axis the look at will use ? The possibles values are:
			-> MegaAssets.Axis.X or 1: Use x axis.
			-> MegaAssets.Axis.Y or 2: Use y axis.
			-> MegaAssets.Axis.Z or 3: Use z axis.
			-> MegaAssets.Axis._X or 4: Use opposite of x axis.
			-> MegaAssets.Axis._Y or 5: Use opposite of y axis.
			-> MegaAssets.Axis._Z or 6: Use opposite of z axis.
		Vector3 oft: Contains the rotation offset of the target bone.
		int fze: Which axis will be froozen ? The possibles values are:
			-> MegaAssets.Axis.NONE or 0: No axis will be froozen.
			-> MegaAssets.Axis.X or 1: freeze x axis.
			-> MegaAssets.Axis.Y or 2: freeze y axis.
			-> MegaAssets.Axis.Z or 3: freeze z axis.
			-> MegaAssets.Axis._X or 4: freeze opposite of x axis.
			-> MegaAssets.Axis._Y or 5: freeze opposite of y axis.
			-> MegaAssets.Axis._Z or 6: freeze opposite of z axis.
			-> MegaAssets.Axis.XY or 7: freeze xy axis.
			-> MegaAssets.Axis.XZ or 8: freeze xz axis.
			-> MegaAssets.Axis.YZ or 9: freeze yz axis.
			-> MegaAssets.Axis._XY or 10: freeze opposite of xy axis.
			-> MegaAssets.Axis._XZ or 11: freeze opposite of xz axis.
			-> MegaAssets.Axis._YZ or 12: freeze opposite of yz axis.
			-> MegaAssets.Axis.XYZ or 13: freeze xyz axis.
			-> MegaAssets.Axis._XYZ or 14: freeze opposite of xyz axis.
"""
static func get_ik_look_at (skn: NodePath, bme: String, tar: NodePath, obj: Node, dir: int = 2, oft: Vector3 = Vector3.ZERO, fze: int = 0) -> Transform:
	# Get the real skeleton and target nodes.
	var sktn = obj.get_node_or_null (skn); var targ = obj.get_node_or_null (tar);
	# Check skeleton value.
	if sktn is Skeleton:
		# Get the bone index.
		var bone_index: int = sktn.find_bone (bme);
		# If no bone is found.
		if bone_index == -1: _output (("The given bone name isn't defined on {" + sktn.name + "}."), Message.ERROR);
		# The bone is defined.
		else:
			# Check target value.
			if targ is Spatial:
				# Get the bone's global transform pose.
				var rest: Transform = sktn.get_bone_global_pose (bone_index);
				# Convert our position relative to the skeleton's transform.
				var target_pos = sktn.global_transform.xform_inv (targ.global_transform.origin);
				# Call helper's look_at function with the chosen up axis.
				if dir <= Axis.X: rest = rest.looking_at (target_pos, Vector3.RIGHT); elif dir == Axis.Y: rest = rest.looking_at (target_pos, Vector3.UP);
				elif dir == Axis.Z: rest = rest.looking_at (target_pos, Vector3.FORWARD); elif dir == Axis._X: rest = rest.looking_at (target_pos, -Vector3.RIGHT);
				elif dir == Axis._Y: rest = rest.looking_at (target_pos, -Vector3.UP); else: rest = rest.looking_at (target_pos, -Vector3.FORWARD);
				# Get the rotation euler of the bone and of this node.
				var rest_euler: Vector3 = rest.basis.get_euler (); var tar_euler: Vector3 = targ.global_transform.basis.orthonormalized ().get_euler ();
				# Flip the rotation euler if using negative rotation.
				if fze == Axis._X || fze == Axis._Y || fze == Axis._Z || fze == Axis._XY || fze == Axis._XZ\
				|| fze == Axis._YZ || fze == Axis._XYZ: tar_euler = -tar_euler;
				# Apply this node's rotation euler on each axis, with negative rotation whether possible.
				if fze == Axis.X: rest_euler = Vector3 (tar_euler.x, rest_euler.y, rest_euler.z);
				elif fze == Axis.Y: rest_euler = Vector3 (rest_euler.x, tar_euler.y, rest_euler.z);
				elif fze == Axis.Z: rest_euler = Vector3 (rest_euler.x, rest_euler.y, tar_euler.z);
				elif fze == Axis.XY: rest_euler = Vector3 (tar_euler.x, tar_euler.y, rest_euler.z);
				elif fze == Axis.XZ: rest_euler = Vector3 (tar_euler.x, rest_euler.y, tar_euler.z);
				elif fze == Axis.YZ: rest_euler = Vector3 (rest_euler.x, tar_euler.y, tar_euler.z);
				elif fze >= Axis.XYZ: rest_euler = Vector3 (tar_euler.x, tar_euler.y, tar_euler.z);
				# Make a new basis with the, potentially, changed euler angles.
				rest.basis = Basis (rest_euler);
				# Apply rotation offset to the bone.
				if oft != Vector3.ZERO:
					# Make the rotation with the given rotation offset.
					rest.basis = rest.basis.rotated (rest.basis.x, deg2rad (oft.x));
					rest.basis = rest.basis.rotated (rest.basis.y, deg2rad (oft.y));
					rest.basis = rest.basis.rotated (rest.basis.z, deg2rad (oft.z));
				# Return the final transform value.
				return rest;
			# Error message.
			else: _output ("Missing target !", Message.ERROR);
	# Error message.
	else: _output ("Missing skeleton node !", Message.ERROR); return Transform.IDENTITY;

"""
	@Description: Listen editor notifications to run configurations from script variables structure.
	@Parameters:
		int what: Which editor notifications will be listen ?
"""
func listen_notifications (what: int, delay: float = 0.0) -> void:
	# Waiting for user delay.
	if !Engine.editor_hint && delay > 0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Run all notifications settings from the current property.
	for elmt in self.__props__:
		# For notification option.
		if self.__props__ [elmt].notification != null:
			# Dictionary type.
			if self.__props__ [elmt].notification is Dictionary: self._prop_require_notification_manager (elmt, self.__props__ [elmt].notification, what);
			# For an array type.
			elif self.__props__ [elmt].notification is Array:
				# Run all configurations about each notification statement.
				for item in self.__props__ [elmt].notification: if item is Dictionary: self._prop_require_notification_manager (elmt, item, what);

"""
	@Description: Returns value of an index or key from an array or a dictionary.
	@Parameters:
		Variant id: Contains an id.
		Dictionary | Array | String input: Contains a dictionary or an array.
		int index: Which value of the given id would you get ?
		int count: Contains the result count. A negative value will return all found results.
		bool rev: Do you want to inverse treatment ?
		bool rec: Do you want to use a recursive program to get an id value ?
"""
static func get_id_value_of (id, input, index: int = -1, count: int = -1, rev: bool = false, rec: bool = true):
	# The given is not equal to zero.
	if count != 0:
		# Contains the input state type.
		var ste: Array = Array ([input is Dictionary, is_array (input)]);
		# The given input is a true array with an index.
		if input is String:
			# The count is less than zero.
			id = index if index >= 0 and not id is int else id;
			# Check id value type.
			if id is int:
				# The count is less than zero.
				if count < 0: return input [id];
				# The given index is valid.
				elif index_validation (id, input.length ()):
					# Contains the filtered values.
					var filter: String = String ('');
					# Getting all values from the given interval.
					for u in range (id, (len (input) if count > ((len (input) - 1) - id) else (id + count)), 1): filter += input [u];
					# Check direction.
					return filter if !rev else array_invert (filter);
			# Otherwise.
			else: return null;
		# An index has been specified.
		elif index >= 0:
			# Getting all values of the given id.
			var result = get_id_value_of (id, input, -1, -1, rev, rec);
			# Converting result into an array.
			result = Array ([result]) if not result is Array else result;
			# The count is less than zero.
			if count < 0: return result [index] if index_validation (index, result.size ()) else null;
			# The given index is valid.
			elif index_validation (index, result.size ()):
				# Contains the filtered values.
				var filter: Array = Array ([]);
				# Getting all values from the given interval.
				for g in range (index, (len (result) if count > ((len (result) - 1) - index) else (index + count)), 1): filter.append (result [g]);
				# Get filtered size and return the final result.
				var length: int = len (filter); if length <= 0: return null; elif length == 1: return filter [0]; else: return filter;
		# The given input is a dictionary.
		elif ste [0] || ste [1] && typeof (id) != TYPE_INT:
			# Contains all found values from the given input.
			var values: Array = Array ([]); id = id.lstrip (' ').rstrip (' ') if id is String else id;
			# Search the given key in other nested dictionary.
			for item in input:
				# It found the given key.
				if ste [0] && typeof (item) == typeof (id) && item == id:
					# Check count value.
					if count < 0 || count > 0 && len (values) < count: values.append (input [item]); else: break;
				# The value of the current key is a nested array or dictionary.
				elif rec && ste [0] && input [item] is Array || rec && ste [0] && input [item] is Dictionary\
				|| rec && ste [1] && item is Dictionary || rec && ste [1] && item is Array:
					# Contains all found values from the given array.
					var value = get_id_value_of (id, input [item] if ste [0] else item, -1, count, false, true);
					# The value isn't null.
					if value != null:
						# For an array type.
						if value is Array:
							# Getting all found keys values.
							for elmt in value:
								# Getting the found value.
								if count < 0 || count > 0 && len (values) < count: values.append (elmt); else: break;
						# For other type.
						elif count < 0 || count > 0 && len (values) < count: values.append (value); else: break;
			# Check direction.
			values = values if !rev else array_invert (values);
			# Get values size and return the final result.
			var size: int = len (values); if size <= 0: return null; elif size == 1: return values [0]; else: return values;
		# The given input value is other data type.
		else: return input;
	# Otherwise.
	else: return null;

"""
	@Description: Adds one or severals property(ies) to a script. Before continuing, you should know that the
		following keys can be manipulated in the use of keys: "showif, disableif, require, changed, min, max,
		button, clone and notification".
		-> String | bool statement: Contains the developer's statement. If you donate a string, then it will
			have to close a condition which is exactly like the declarations you make when you define a
			condition in programming, but with a few differences.
			Example:
				"property1 > 56 || property2 != ?property3 and !property4"
				"method1 () == not option"
				"property5 <= ?method2 () and property4 or !method1 ()"
				"StringProperty == null" => Will check if "StringProperty" in string format is empty ('')
			The question mark means that we wants to fetch the value that another predefined property or method
			returns. The mathematical expressions and parameterizable method calls are not supported in a
			statement. However, if you want to retrieve the value of a key or an index of position contained
			in a dictionary or table you must adopt the nomenclature: "PropertyName.KeyName/PositionIndex".
			Example: "table1.2 > ?table2.0 || dictionary1.2 != ?dictionary3.level".
			However, only use this key if you are handling the following keys: "showif, disableif, clone, require and notification."
		-> Array | Dictionary actions: Contains the different configurations on how actions will be performed
			upon verification of certain conditions. If you give an array, then it should only contain dictionaries
			supporting the same keys as if you pass an ordinary dictionary. If you give a dictionary, then it
			will support the following keys:
				-> String slot: Contains the name of the method or property to be called when the execution conditions are validated.
				-> Variant value: This key is to be used only when the action to be performed is on a property.
					It contains the value assigned to the property in question, if you did not pass a dictionary.
					Otherwise, you will be required to redefine the property with any keys you use to the creation
					of a property via "bind_props ()" method.
				-> Array params: Contains the values ​​of different parameters of the targeted method. This key
					is to be used only when the action to be performed is on a method. The filling of this table,
					must be respected the order of alignment of the parameters of the method in question. No need
					to use this key, the method has no parameter (s) or can take no argument (s). You can get
					property value or method result from parameters with some specials keywords ("?PropertyName"
					or "?MethodName()"). Only on ("value", "changed" and "actions") keys.
				-> String message: Contains the message to be displayed when the execution conditions are validated.
				-> int type = 2: What is the type of the message to printed ?
		-> String callback: Containts a method name (only on "value" and "changed" keys).
	@Parameters:
		Array | Dictionary data: Contains the property data. This dictionary support the following keys:
			-> String Source: What is the property source ?
			-> int index = -1: Control property position hierarchy.
			-> Variant value = null: Contains the value of the property in question. Adapt the value of your
				property according to the type chosen. It is important to do this if you don't want bizzard results.
				If you spend a character string as value, you will be able to retrieve the value of an another
				property or result that a method returns. Example:
					"?property" will set the targeted property to the value of property.
					"?method ()" will affect the targeted property, which returns method.
				You also have the possibility to give a dictionary containing the following keys: "callback" and "params".
			-> int type = 0: Contains the choosed type of the property.
			-> int hint = 0: Contains the property hint.
			-> int usage = 71: Contains the property usage on the editor.
			-> String title: Do you want to change script category name ? If you give a string value, the named category "Script Variables" will set to your value.
			-> Vector2 | Vector3 range: Create a range property with range constraints. If you passed a vector3, the third value containts the range step.
			-> String hint_string: Use this key to group severals values into a dropdown.
			-> bool visible = true: The current will visible on editor inspector ?
			-> bool enabled = true: Control property activation and desactivation.
			-> bool private = false: This property is it private ?
			-> String | PoolStringArray attach: Do you want to attach properties to this property? To make an
			attachment, you must give the name(s) of the property(s) whose behavior depends on this property.
			Example: Let "property1", "property2", "property3" and "property4" be four properties of the script.
			The behaviors of properties 2 and 3 depend on the value of "property1" and that of "property4", that of
			"property3". Thus, the value of the "attach" key of "property1" will target the names of properties 2 and 3;
			that of "property3" will target the "property4" name. Note that using this key optimizes the execution of
			configurations carried out at the level of all the properties of the script. It formally recommended to
			use it to avoid executions outside the predefined domain.
			-> bool duplicate = false: Do you want to repeat the last element value foreach add ? (Work on array only).
			-> String | Dictionary button: Create a boolean property that work as a button.
			-> int stream = 2: Control the property access mode. The possibles values are:
				-> MegaAssets.PropertyAccessMode.READ_ONLY or 0: You can access to this property on read only.
				-> MegaAssets.PropertyAccessMode.WRITE_ONLY or 1: You can access to this property on write only.
				-> MegaAssets.PropertyAccessMode.BOTH or 2: You can access to this property on read and write.
			-> bool saveable = false: Do you want to configure the property to respond to saving and loading script data? Use this property only if your script
				inherits from the class "Saveable" or "Recordable".
			-> String | Dictionary changed: Calls a callback when property value has changed. If you call a method with two or many parameters, the value of the
				first and the second argument will be respectively replaced to property name and his value. Don't forget this detail.
			-> Variant | Dictionary dropdown: Convert the property into an enumerator. You can give a behavior to
				your dropdown think a dictionary that support the following keys:
					-> Variant value: Containts the dropdown value.
					-> int behavior: Which behavior used ? The possbles values are:
						-> MegaAssets.NaughtyAttributes.INPUT_MAP or 0: Get Godot editor input map.
						-> MegaAssets.NaughtyAttributes.SIGNALS or 1: Get current available script signals list.
						-> MegaAssets.NaughtyAttributes.TAGS or 2: Get current node groups.
						-> MegaAssets.NaughtyAttributes.METHODS or 3: Get current available script methods list.
						-> MegaAssets.NaughtyAttributes.TYPES or 4: Get Godot base types list.
						-> MegaAssets.NaughtyAttributes.OPERATORS or 5: Get Godot available operators list.
						-> MegaAssets.NaughtyAttributes.MOUSE_CONTROLS or 6: Get mouse controls. You can also get keycodes by
							enabling "keycodes" key from dropdown configurations. Same thing for gamepad and keyboard controls.
						-> MegaAssets.NaughtyAttributes.GAMEPAD_CONTROLS or 7: Get joystick controls.
						-> MegaAssets.NaughtyAttributes.DESKTOP_RESOLUTIONS or 8: Get all possibles desktop resolutions.
							You can also get sizes by enabling "sizes" key from dropdown configurations. Same thing
							for ipad, iphone and android resolutions.
						-> MegaAssets.NaughtyAttributes.IPAD_RESOLUTIONS or 9: Get all possibles ipad resolutions.
						-> MegaAssets.NaughtyAttributes.IPHONE_RESOLUTIONS or 10: Get all possibles iphone resolutions.
						-> MegaAssets.NaughtyAttributes.ANDROID_RESOLUTIONS or 11: Get all possibles android resolutions.
						-> MegaAssets.NaughtyAttributes.KEYBOARD_CONTROLS or 12: Get keyboard controls.
						-> MegaAssets.NaughtyAttributes.SYSTEM_DIR or 13: Get the list of available paths on the installed system operating system.
							Note that you can also retrieve the paths by setting the "paths" key to true.
						-> MegaAssets.NaughtyAttributes.GAME_CONTROLLERS or 14: Retrieves the list of controls connected to
							the game. Note that this option listened to the commands connected to the computer to
							give in real time orders available. Note that the behaviors of a dropdown list have
							priority over the value of the latter itself.
			-> String | Dictionary showif: Show a property into the editor inspector with a certains conditions.
				Same thing for "disableif" key which takes care of the activation as well as the deactivation of a property.
			-> float | int | Dictionary | Vector2 | Vector3 min: Forces the property's value to stay at the
				minimum imposed. Note that this key is only used if the type of the property is an integer,
				real, 2d vector or 3d vector. If you give a dictionary, then it will support the keys following:
					-> float | int | Vector2 | Vector3 value: Contains the min value.
					-> int index = -1: What value do you want targeted ? Only use this key if the property
						you are manipulating is a 2d vector or 3d vector.
				Same thing for "max" key.
			-> Array | Dictionary clone: Detects presence of duplicates depending on the identifier given to
				it. If you give a table, then this should only contain dictionaries supporting the same keys
				as if you skip an ordinary dictionary. If you give a dictionary, then it will support following
				keys:
					-> Variant id: Contains an identifier of which you want to check for duplications within these values.
					-> int limit = 1: What is the criterion for repeating the values ​​of the chosen identifier ?
			-> Array | Dictionary | String require: Adds some constraints to property value. If you give a string
				of characters, it will be considered as an error message to be displayed when will not change the
				initial value of the property. If you give an array, then this This should only contain
				dictionaries supporting the same keys as if you pass a ordinary dictionary.
			-> Array | Dictionary notification: Listen to them notifications from the editor to then execute
				the configurations made to his espect. If you give an array, then it should only contain
				dictionaries supporting the same keys as if you pass an ordinary dictionary. You can pass a
				dictionary with the following keys:
					-> int what: Which editor notifications will be listen ?
"""
func bind_prop (data, delay: float = 0.0) -> void:
	# Game is running.
	if !Engine.editor_hint && delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Transforms data parameter into an array.
	data = Array ([data]) if not self.is_array (data) else Array (data);
	# Add all given properties.
	for prop in data:
		# The given data is a dictionary.
		if prop is Dictionary:
			# Correct the given data.
			var res: Array = self._correct_data (prop); prop = res [0];
			# Contains the user source value.
			if res [1] [0] and prop.source is String:
				# Correct the given source name.
				prop.source = str_replace (prop.source, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
				# The source is correct.
				if !prop.source.empty () && prop.source != '/':
					# This property is not defined on the script properties.
					if !self.__props__.has (prop.source):
						# Collect all given data into a new dictionary.
						var prop_data: Dictionary = Dictionary ({
							value = prop.value if res [1] [1] else null, _oldvalue = prop.value if res [1] [1] else null,
							type = prop.type if res [1] [2] && prop.type is int else TYPE_NIL,
							hint = prop.hint if res [1] [3] && prop.hint is int else PROPERTY_HINT_NONE,
							usage = prop.usage if res [1] [4] && prop.usage is int else PROPERTY_USAGE_DEFAULT_INTL,
							visible = prop.visible if res [1] [5] && prop.visible is bool else true,
							stream = prop.stream if res [1] [6] && prop.stream is int else 2,
							private = prop.private if res [1] [7] && prop.private is bool else false,
							changed = prop.changed if res [1] [8] else null, button = prop.button if res [1] [11] else null,
							index = prop.index if res [1] [9] && prop.index is int else -1,
							duplicate = prop.duplicate if res [1] [10] && prop.duplicate is bool else false,
							enabled = prop.enabled if res [1] [12] && prop.enabled is bool else true,
							disableif = prop.disableif if res [1] [13] else null, showif = prop.showif if res [1] [14] else null,
							require = prop.require if res [1] [15] else null, min = prop.min if res [1] [16] else null,
							max = prop.max if res [1] [17] else null, clone = prop.clone if res [1] [18] else null,
							notification = prop.notification if res [1] [19] else null, attach = prop.attach if res [1] [20] else null,
							saveable = prop.saveable if res [1] [21] && prop.saveable is bool else false,
							hint_string = prop._hint_str if prop.has ("_hint_str") else null,
							_drop_opt = prop._drop_opt if prop.has ("_drop_opt") && prop._drop_opt is int else null
						}); self.__props__ [prop.source] = prop_data; self.property_list_changed_notify ();
				# Error message.
				else: self._output ("Invalid source key input.", Message.ERROR);
			# Error message.
			else: self._output ("Missing property source !", Message.ERROR);

"""
	@Description: Resets value of one or many properties.
	@Parameters:
		String trigger: Which property name calls this method ? It's very important whether you want to reset value of all script properties.
		Variant prop: Contains all properties names which value will be reset.
		float delay: What is the timeout before starting reset ?
"""
func reset_props_value (trigger: String, prop = null, delay: float = 0.0) -> void:
	# Game is running.
	if !Engine.editor_hint && delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Get all module properties.
	prop = self.__props__.keys () if prop == null && len (self.__props__) > 0 else prop;
	# Prop property isn't null.
	if prop != null:
		# Correct the given trigger name.
		trigger = str_replace (trigger, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
		# Convert prop into an PoolStringArray.
		prop = Array ([prop]) if !self.is_array (prop) else Array (prop); prop = PoolStringArray (prop);
		# Search each all given properties.
		for p in prop:
			# Remove left and right spaces.
			p = p.lstrip (' ').rstrip (' '); p = self._prop_name_accuracy (p);
			# The current property is defined.
			if self.__props__.has (p):
				# Get the old property value.
				self.__props__ [p].value = self.__props__ [p]._oldvalue;
				# The current property name is not equal to the trigger.
				if !trigger.empty () and p != trigger:
					# Calls the given callback whether it exists and run property constraints.
					self._prop_value_changed (p); self._run_constraints (p);
		# Refresh the given property value.
		self.property_list_changed_notify ();

"""@Description: Returns all properties from "__props__" dictionary.
	@Parameters:
		bool invert: Do you want to reverse the alignment order of the properties ?
"""
func get_properties (invert: bool = false) -> Array:
	# Contains all properties of the module.
	var properties: Array = Array ([]); var index: int = 0;
	# Get all properties with a certains conditions.
	for prop in self.__props__:
		# Check property visibility.
		if self.__props__ [prop].visible:
			# Contains the property data.
			var prop_data: Dictionary = Dictionary ({
				name = prop, hint_string = self.__props__ [prop].hint_string, type = self.__props__ [prop].type,
				usage = self.__props__ [prop].usage, hint = self.__props__ [prop].hint
			});
			# The property index is inside range array.
			if self.is_range (self.__props__ [prop].index, 0, (len (properties) - 1)) || self.__props__ [prop].index == index:
				# Insert the given property and go to the next index.
				index = self.__props__ [prop].index; properties.insert (index, prop_data); index += 1;
			# Otherwise.
			else:
				# Insert the given property and go to the next index.
				properties.insert (index, prop_data); index += 1;
	# Return the final result.
	return self.array_invert (properties) if invert else properties;

"""
	@Description: Destroys the given properties from his name from "__props__" dictionary.
	@Parameters:
		String | PoolStringArray source: Contains properties names or their source.
		float delay: What is the timeout before destroying properties ?
"""
func destroy_props (source, delay: float = 0.0) -> void:
	# Game is running.
	if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout");
	# Transforms source parameter into an array.
	source = Array ([source]) if not self.is_array (source) else Array (source); source = PoolStringArray (source);
	# Destroy all given properties.
	for src in source:
		# Correct the given source value.
		src = str_replace (src, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '); src = self._prop_name_accuracy (src);
		# The source name isn't empty.
		if not src.empty ():
			# Search and destroy the given source.
			for prop in self.__props__:
				# The source contains '/' character.
				if src.find ('/') == -1:
					# Destroys this property from the script.
					if src == prop and self.__props__.erase (prop): break;
				# Otherwise.
				elif prop.begins_with (src) && self.__props__.erase (prop): pass;
	# Refresh script properties data.
	self.property_list_changed_notify ();

"""
	@Description: Overrides a property.
	@Parameters:
		Dictionary data: Contains useful data to the new property.
		String prop_name: Contains property name.
		float delay: What is the timeout before redefinition ?
"""
func override_prop (data: Dictionary, prop_name: String, delay: float = 0.0) -> void:
	# Game is running.
	if !Engine.editor_hint && delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
	# Correct the passed property name.
	prop_name = str_replace (prop_name, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '); prop_name = self._prop_name_accuracy (prop_name);
	# Check old property name value.
	if not prop_name.empty ():
		# Check property name into the module properties data.
		if self.__props__.has (prop_name):
			# Correct the given data.
			var res: Array = self._correct_data (data); data = res [0];
			# Correct source assign.
			data.source = prop_name if !res [1] [0] else data.source;
			# Remove left and right spaces.
			data.source = str_replace (data.source, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' ');
			# Check source value.
			if !data.source.empty () && data.source != '/':
				# The property name changed.
				if data.source != prop_name:
					# The all data from the old property.
					var prop_data: Dictionary = self.__props__ [prop_name];
					# Replace the old property to the new property.
					if self.__props__.erase (prop_name): self.__props__ [data.source] = prop_data;
				# Configure the given data.
				self.__props__ [data.source].value = data.value if res [1] [1] else self.__props__ [data.source].value;
				self.__props__ [data.source]._oldvalue = data.value if res [1] [1] && typeof (self.__props__ [data.source]._oldvalue)\
					!= typeof (data.value) else self.__props__ [data.source]._oldvalue;
				self.__props__ [data.source].type = data.type if res [1] [2] && data.type is int else self.__props__ [data.source].type;
				self.__props__ [data.source].hint = data.hint if res [1] [3] && data.hint is int else self.__props__ [data.source].hint;
				self.__props__ [data.source].usage = data.usage if res [1] [4] && data.usage is int else self.__props__ [data.source].usage;
				self.__props__ [data.source].visible = data.visible if res [1] [5] && data.visible is bool else self.__props__ [data.source].visible;
				self.__props__ [data.source].stream = data.stream if res [1] [6] && data.stream is int else self.__props__ [data.source].stream;
				self.__props__ [data.source].private = data.private if res [1] [7] && data.private is bool else self.__props__ [data.source].private;
				self.__props__ [data.source].changed = data.changed if res [1] [8] else self.__props__ [data.source].changed;
				self.__props__ [data.source].index = data.index if res [1] [9] && data.index is int else self.__props__ [data.source].index;
				self.__props__ [data.source].duplicate = data.duplicate if res [1] [10] && data.duplicate is bool else self.__props__ [data.source].duplicate;
				self.__props__ [data.source].button = data.button if res [1] [11] else self.__props__ [data.source].button;
				self.__props__ [data.source].enabled = data.enabled if res [1] [12] && data.enabled is bool else self.__props__ [data.source].enabled;
				self.__props__ [data.source].disableif = data.disableif if res [1] [13] else self.__props__ [data.source].disableif;
				self.__props__ [data.source].showif = data.showif if res [1] [14] else self.__props__ [data.source].showif;
				self.__props__ [data.source].require = data.require if res [1] [15] else self.__props__ [data.source].require;
				self.__props__ [data.source].min = data.min if res [1] [16] else self.__props__ [data.source].min;
				self.__props__ [data.source].max = data.max if res [1] [17] else self.__props__ [data.source].max;
				self.__props__ [data.source].clone = data.clone if res [1] [18] else self.__props__ [data.source].clone;
				self.__props__ [data.source].notification = data.notification if res [1] [19] else self.__props__ [data.source].notification;
				self.__props__ [data.source].attach = data.attach if res [1] [20] else self.__props__ [data.source].attach;
				self.__props__ [data.source].saveable = data.saveable if res [1] [21] && data.saveable is bool else self.__props__ [data.source].saveable;
				self.__props__ [data.source].hint_string = data._hint_str if data.has ("_hint_str") else self.__props__ [data.source].hint_string;
				self.__props__ [data.source]._drop_opt = data._drop_opt if data.has ("_drop_opt") else self.__props__ [data.source]._drop_opt;
				# Refresh script properties data.
				self.property_list_changed_notify ();
			# Error message.
			else: self._output ("Invalid source key input.", Message.ERROR);
	# Error message.
	else: self._output ("Missing the old property name !", Message.ERROR);

"""
	@Description: Returns a string format of the given input.
	@Parameters:
		Variant input: Contains an input.
"""
static func any_to_str (input) -> String:
	# For an array.
	if is_array (input):
		# Converting the given array to string.
		var string: String = ''; for item in input: string += str (item); return string;
	# For a string.
	elif input is String: return input; else: return str (input);

"""
	@Description: Returns the inversed form of an array.
	@Parameters:
		Array | String array: Contains an array. This method accepts a string value.
"""
static func array_invert (array):
	# The given array is a true array.
	if is_array (array):
		# Return the inverted array form.
		var inv: Array = Array ([]); for elmt in range ((array.size () - 1), -1, -1): inv.append (array [elmt]); return inv;
	# For a string.
	elif array is String:
		# Return an inverted string.
		var string: String = ''; for idx in range ((array.length () - 1), -1, -1): string += array [idx]; return string;
	# Return the same value.
	else: return array;

"""
	@Description: What are the values ​​whose number of occurrences is immediately greater than the imposed limit ?
	@Parameters:
		Variant id: Contains an id.
		Variant input: Contains a dictionary or an array.
		int limit: What is the criterion for repeating values ?
"""
static func get_clones_of (id, input, limit: int = 1):
	# Correct the given limit value and getting found values.
	limit = 1 if limit < 1 else limit; var found: Array = Array ([]); var values = get_id_value_of (id, input, -1);
	# The given values is an array.
	if values is Array:
		# Check clones.
		for val in values: if values.count (val) > limit && !found.has (val): found.append (val);
	# Return the final result.
	var sz: int = len (found); if sz <= 0: return null; elif sz == 1: return found [0]; else: return found;

"""
	@Description: Sets value of a given id on a dictionary or an array.
	@Parameters:
		Variant id: Contains an id.
		Variant value: Contains the new id value.
		Variant input: Contains a dictionary or an array.
		int index: which id reference would you want to change value ?
		bool typed: Do you want to check the type of the given id value before any change ?
		bool rec: Do you want to use a recursive program to set an id value ?
"""
static func set_id_value_of (id, value, input, index: int = -1, typed: bool = false, rec: bool = true): return _set_id_val (id, value, input, index, typed, rec, -1) [0];

"""
	@Description: Returns all possibles screen resolutions about desktop computers.
	@Parameters:
		bool to_string: Do you want to get a string format ?
"""
static func get_desktop_resolutions (to_string: bool = true):
	# String format is requested.
	if to_string:
		# Returns resolutions as string format.
		return PoolStringArray ([
			"nHD_16-9 (640x360)", "SVGA_4-3 (800x600)", "XGA_4-3 (1024x768)", "WXGA_16-9 (1280x720)",
			"WXGA_16-10 (1280x800)", "SXGA_5-4 (1280x1024)", "HD_16-9 (1366x768)", "WXGA+_16-10 (1440x900)",
			"other_16-9 (1536x864)", "HD+_16-9 (1600x900)", "WSXGA+_16-10 (1680x1050)", "FHD_16-9 (1920x1080)",
			"WUXGA_16-10 (1920x1200)", "QWXGA_16-9 (2048x1152)", "2K_21-9 (2560x1080)", "QHD_16-9 (2560x1440)",
			"other_21-9 (3440x1440)", "4K_UHD_16-9 (3840x2160)", "8K_16-9 (7680x4320)"
		]);
	# Otherwise.
	else: return PoolVector2Array ([
		Vector2 (640, 360), Vector2 (800, 600), Vector2 (1024, 768), Vector2 (1280, 720), Vector2 (1280, 800),
		Vector2 (1280, 1024), Vector2 (1366, 768), Vector2 (1440, 900), Vector2 (1536, 864), Vector2 (1600, 900),
		Vector2 (1680, 1050), Vector2 (1920, 1080), Vector2 (1920, 1200), Vector2 (2048, 1152), Vector2 (2560, 1080),
		Vector2 (2560, 1440), Vector2 (3440, 1440), Vector2 (3840, 2160), Vector2 (7680, 4320)
	]);

"""
	@Description: Returns all possibles screen resolutions about ipad devices.
	@Parameters:
		bool to_string: Do you want to get a string format ?
"""
static func get_ipad_resolutions (to_string: bool = true):
	# String format is requested.
	if to_string:
		# Returns resolutions as string format.
		return PoolStringArray ([
			"iPad1/2/Mini1_Landscape (1024x768)", "iPad3/4/Air/Air2_Landscape (2048x1536)",
			"iPad5th/Pro9.7_Landscape (2048x1536)", "iPadMini2/3/4_Landscape (2048x1536)",
			"iPadPro10.5_Landscape (2224x1668)", "iPadPro12.9/2017_Landscape (2732x2048)",
			"iPad1/2/Mini1_Portrait (768x1024)", "iPad3/4/Air/Air2_Portrait (1536x2048)",
			"iPad5th/Pro9.7_Portrait (1536x2048)", "iPadMini2/3/4_Portrait (1536x2048)",
			"iPadPro10.5_Portrait (1668x2224)", "iPadPro12.9/2017_Portrait (2048x2732)"
		]);
	# Otherwise.
	else: return PoolVector2Array ([
		Vector2 (1024, 768), Vector2 (2048, 1536), Vector2 (2224, 1668), Vector2 (2732, 2048),
		Vector2 (768, 1024), Vector2 (1536, 2048), Vector2 (1668, 2224), Vector2 (2048, 2732)
	]);

"""
	@Description: Returns all possibles screen resolutions about iphone devices.
	@Parameters:
		bool to_string: Do you want to get a string format ?
"""
static func get_iphone_resolutions (to_string: bool = true):
	# String format is requested.
	if to_string:
		# Returns resolutions as string format.
		return PoolStringArray ([
			"iPhone2G/3G/3GS_Landscape (480x320)", "iPhone4/4S_Landscape (960x640)", "iPhoneXR_Landscape (1792x828)",
			"iPhone5/5S/5C/SE_Landscape (1136x640)", "iPhoneX/XS_Landscape (2436x1125)", "iPhone4/4S_Portrait (640x960)",
			"iPhone6/6S/7/8_Landscape (1334x750)", "iPhoneX/XS_Portrait (1125x2436)", "iPhoneXR_Portrait (828x1792)",
			"iPhone6/6S/7/8_Portrait (750x1334)", "iPhoneXSMax_Portrait (1242x2688)", "iPhoneXSMax_Landscape (2688x1242)",
			"iPhone2G/3G/3GS_Portrait (320x480)", "iPhone5/5S/5C/SE_Portrait (640x1136)",
			"iPhone6+/6S+/7+/8+_Portrait (1242x2208)", "iPhone6+/6S+/7+/8+_Landscape (2208x1242)",
		]);
	# Otherwise.
	else: return PoolVector2Array ([
		Vector2 (480, 320), Vector2 (960, 640), Vector2 (1792, 828), Vector2 (1136, 640), Vector2 (2436, 1125),
		Vector2 (640, 960), Vector2 (1134, 750), Vector2 (1125, 2436), Vector2 (828, 1792), Vector2 (750, 1334),
		Vector2 (1242, 2688), Vector2 (2688, 1242), Vector2 (320, 480), Vector2 (640, 1136), Vector2 (1242, 2208),
		Vector2 (2208, 1242)
	]);

"""
	@Description: Returns all possibles screen resolutions about android devices.
	@Parameters:
		bool to_string: Do you want to get a string format ?
"""
static func get_android_resolutions (to_string: bool = true):
	# String format is requested.
	if to_string:
		# Returns resolutions as string format.
		return PoolStringArray ([
			"FWVGA_Portrait (480x854)", "WSVGA_Portrait (600x1024)", "WVGA_Landscape (800x480)",
			"HVGA_Portrait (320x480)", "WVGA_Portrait (480x800)", "HVGA_Landscape (480x320)",
			"WXGA_Portrait (800x1280)", "FWVGA_Landscape (854x480)", "WXGA_Landscape (1280x800)",
			"WSVGA_Landscape (1024x600)"
		]);
	# Otherwise.
	else: return PoolVector2Array ([
		Vector2 (480, 854), Vector2 (600, 1024), Vector2 (800, 480), Vector2 (320, 480), Vector2 (480, 800),
		Vector2 (480, 320), Vector2 (800, 1280), Vector2 (854, 480), Vector2 (1280, 800), Vector2 (1024, 600)
	]);

"""
	@Description: Returns initialised version of the passed input. Rid and Object types aren't supported on this method.
	@Parameters:
		Variant input: Containts a value. Pay Attention ! Your value must be in range of the base types.
"""
static func get_initialised_type (input):
	# Checking input value type.
	if typeof (input) == TYPE_NIL: return null; elif typeof (input) == TYPE_BOOL: return false;
	elif typeof (input) == TYPE_INT: return 0; elif typeof (input) == TYPE_REAL: return 0.0;
	elif typeof (input) == TYPE_STRING: return ''; elif typeof (input) == TYPE_VECTOR2: return Vector2.ZERO;
	elif typeof (input) == TYPE_RECT2: return Rect2 (Vector2.ZERO, Vector2.ZERO);
	elif typeof (input) == TYPE_VECTOR3: return Vector3.ZERO; elif typeof (input) == TYPE_NODE_PATH: return NodePath ('');
	elif typeof (input) == TYPE_TRANSFORM2D: return Transform2D.IDENTITY; elif typeof (input) == TYPE_PLANE: return Plane (0.0, 0.0, 0.0, 0.0);
	elif typeof (input) == TYPE_QUAT: return Quat (0.0, 0.0, 0.0, 0.0); elif typeof (input) == TYPE_AABB: return AABB (Vector3.ZERO, Vector3.ZERO);
	elif typeof (input) == TYPE_BASIS: return Basis (Vector3.ZERO); elif typeof (input) == TYPE_TRANSFORM: return Transform (Basis (Vector3.ZERO));
	elif typeof (input) == TYPE_COLOR: return Color.black; elif typeof (input) == TYPE_ARRAY: return Array ([]);
	elif typeof (input) == TYPE_DICTIONARY: return Dictionary ({}); elif typeof (input) == TYPE_RAW_ARRAY: return PoolByteArray ([]);
	elif typeof (input) == TYPE_INT_ARRAY: return PoolIntArray ([]); elif typeof (input) == TYPE_REAL_ARRAY: return PoolRealArray ([]);
	elif typeof (input) == TYPE_STRING_ARRAY: return PoolStringArray ([]); elif typeof (input) == TYPE_VECTOR2_ARRAY: return PoolVector2Array ([]);
	elif typeof (input) == TYPE_VECTOR3_ARRAY: return PoolVector3Array ([]); elif typeof (input) == TYPE_COLOR_ARRAY: return PoolColorArray ([]); else: return null;

"""@Description: Returns Godot base types list."""
static func get_godot_base_types () -> PoolStringArray:
	# Returns godot base types.
	return PoolStringArray ([
		"Nil", "Bool", "Int", "Real", "String", "Vector 2", "Rect 2", "Vector 3", "Transform 2D", "Plane", "Quat",
		"Aabb", "Basis", "Transform", "Color", "Node Path", "Rid", "Object", "Dictionary", "Array", "Raw Array",
		"Int Array", "Real Array", "String Array", "Vector2 Array", "Vector3 Array", "Color Array"
	]);

"""@Description: Returns Godot operators list."""
static func get_godot_operators () -> PoolStringArray:
	# Returns godot logic operators.
	return PoolStringArray ([
		"Equal", "Not Equal", "Less", "Less Equal", "Greater", "Greater Equal", "Add", "Substract", "Multiply",
		"Divide", "Negative", "Positive", "Module", "String Concat", "Shift Left", "Shift Right", "Bit And",
		"Bit Or", "Bit Xor", "Bit Negate", "And", "Or", "Xor", "Not", "In"
	]);

"""
	@Description: Returns mouse controls list.
	@Parameters:
		bool keycode: Do you want to get only mouse keycodes ?
"""
func get_mouse_controls (keycode: bool = false):
	# Getting mouse controls names.
	if not keycode: return PoolStringArray ([
		"Left Button 1", "Right Button 2", "Middle Button 3", "Scroll Up 4", "Scroll Down 5", "Scroll Left 6",
		"Scroll Right 7", "XButton1 8", "XButton2 9", "Mask Left Button 1", "Mask Right Button 2",
		"Mask Middle Button 4", "Mask XButton1 128", "Mask XButton2 256"
	]);
	# Getting mouse controls keycodes.
	else: return PoolIntArray ([1, 2, 3, 4, 5, 6, 7, 8, 9, 128, 256]);

"""
	@Description: Returns joystick controls list.
	@Parameters:
		bool keycode: Do you want to get only joystick keycodes ?
"""
func get_joystick_controls (keycode: bool = false):
	# Getting joystick controls names.
	if not keycode: return PoolStringArray ([
		"Joystick Button 0", "Joystick Button 1", "Joystick Button 2", "Joystick Button 3", "Joystick Button 4",
		"Joystick Button 5", "Joystick Button 6", "Joystick Button 7", "Joystick Button 8", "Joystick Button 9",
		"Joystick Button 10", "Joystick Button 11", "Joystick Button 12", "Joystick Button 13", "Joystick Button 14",
		"Joystick Button 15", "Joystick Button 16", "Joystick Axis 0", "Joystick Axis 1", "Joystick Axis 2",
		"Joystick Axis 3", "Joystick Axis 6", "Joystick Axis 7"
	]);
	# Getting joystick controls keycodes.
	else: return PoolIntArray ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

"""
	@Description: Returns keyboard controls list.
	@Parameters:
		bool keycode: Do you want to get only keyboard keycodes ?
"""
func get_keyboard_controls (keycode: bool = false):
	# Contains all keyboard controls as bytes format.
	var keys: PoolIntArray = PoolIntArray ([]);
	# Appending valid keyboard keycodes.
	for k in range (32, 97): keys.append (k); for k in range (123, 127): keys.append (k);
	for k in range (160, 224): keys.append (k); keys.append (247); keys.append (255);
	keys.append (16777217); for k in range (16777218, 16777268): keys.append (k);
	for k in range (16777280, 16777320): if k != 16777301: keys.append (k);
	for k in range (16777346, 16777360): keys.append (k); keys.append (16777345);
	# No keycode required.
	if not keycode:
		# Containts all keyboard keycodes as string format.
		var keycodes: PoolStringArray = PoolStringArray ([]);
		# Converting ascii keycode into string format.
		for keycode in keys: keycodes.append (OS.get_scancode_string (keycode) + " (" + str (keycode) + ')');
		# Return the final result.
		return keycodes;
	# Otherwise.
	else: return keys;

"""
	@Description: The given method or property name(s) is it defined ?
	@Parameters:
		String | PoolStringArray target: What is the target property or method name(s) ?
		Object object: Contains an instance of an object.
"""
static func is_undefined (target, object: Object) -> bool:
	# Converting the given target into a PoolStringArray.
	target = Array ([target]) if !is_array (target) else Array (target); target = PoolStringArray (target);
	# The passed object is not null.
	if object != null:
		# Getting property names.
		var data: Array = get_id_value_of ("name", object.get_property_list ());
		# Check whether all targets is undefined.
		for elmt in target:
			# Correct the current method or property name.
			elmt = str_replace (elmt, ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '(', ')', '[', ']', '{', '}', ',', ';', '.', '-'], '');
			# The given object has the given property or method name.
			if data.has (elmt): return false; elif get_id_value_of ("name", object.get_method_list ()).has (elmt): return false;
	# The given object has all given targets.
	return true;

"""
	@Description: Changes value of the given property with a large field.
	@Parameters:
		String pname: Contains the property name.
		Variant value: Contains the property value.
		Object object: Contains an instance of an object.
		float delay: What is the timeout before changing property value ? Note that if you give the reference of an object that is not
			the instance of a node, you will be exempt from using this parameter.
"""
static func set_var (pname: String, value, object: Object, delay: float = 0.0) -> void:
	# The given object reference is not null.
	if object != null:
		# The target property name is not empty.
		if not pname.empty ():
			# Waiting for user delay.
			if !Engine.editor_hint && object is Node && delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
			# Getting script properties names and his prefix.
			var data: Array = get_id_value_of ("name", object.get_property_list ()); var prefix: String = get_object_prefix (object);
			# The given object is a MagaAssets module.
			if object.has_method ("is_dont_destroy_mode") and object.is_dont_destroy_mode () is bool:
				# The special "__props__" property is defined.
				if data.has ("__props__") && object.has_method ("set_prop") && object.get_prop (pname) != null: object.set_prop (pname, value);
				# The given property is directly defined on the script variables.
				elif pname in data: object.set (str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '), value);
				# Error message.
				else: _output (("Undefined {" + pname + "} property on {" + prefix + "} instance."), Message.ERROR);
			# The given property is directly defined on the script variables.
			elif pname in data: object.set (str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '), value);
			# Error message.
			else: _output (("Undefined {" + pname + "} property on {" + prefix + "} instance."), Message.ERROR);
		# Warning message.
		else: _output ("Missing property name.", Message.WARNING);
	# Warning message.
	else: _output ("Your object reference mustn't be null.", Message.WARNING);

"""
	@Description: Gets value of the given property with a large field.
	@Parameters:
		String pname: Contains the property name.
		Object object: Contains an instance of an object.
		bool dropdown: To return any dropdown value as string format and other value type.
"""
static func get_var (pname: String, object: Object, dropdown: bool = false):
	# The given object reference is not null.
	if object != null:
		# The target property name is not empty.
		if not pname.empty ():
			# Getting script properties names and his prefix.
			var data: Array = get_id_value_of ("name", object.get_property_list ()); var prefix: String = get_object_prefix (object);
			# The given object is a MagaAssets module.
			if object.has_method ("is_dont_destroy_mode") and object.is_dont_destroy_mode () is bool:
				# The special "__props__" property is defined.
				if data.has ("__props__") && object.has_method ("get_prop") && object.get_prop (pname) != null: return object.get_prop (pname, dropdown);
				# The given property is directly defined on the script variables.
				elif pname in data: return object.get (str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '));
				# Error message.
				else: _output (("Undefined {" + pname + "} property on {" + prefix + "} instance."), Message.ERROR);
			# The given property is directly defined on the script variables.
			elif pname in data: return object.get (str_replace (pname, ["\n", "\t", "\a", "\b", "\r", "\v", "\f"], '').lstrip (' ').rstrip (' '));
			# Error message.
			else: _output (("Undefined {" + pname + "} property on {" + prefix + "} instance."), Message.ERROR);
		# Warning message.
		else: _output ("Missing property name.", Message.WARNING);
	# Warning message.
	else: _output ("Your object reference mustn't be null.", Message.WARNING); return null;

"""
	@Description: Returns a basic object infos from his instance.
	@Parameters:
		Object object: Contains an instance of an object.
"""
static func get_object_prefix (object: Object) -> String:
	# Getting object name and return it.
	return (object.get_class () + " [" + object.name + ']') if object is Node && !object.name.empty () else object.get_class ();

"""
	@Description: Returns usefull game statistiques.
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
"""
static func get_game_statistiques (object: Node) -> Dictionary:
	# Return the current game statistiques.
	return Dictionary ({
		"Fps": Engine.get_frames_per_second (), "Object Count": object.get_tree ().get_node_count (), "Frames": object.get_tree ().get_frame (),
		"Window Width": (str (OS.get_real_window_size ().x) + "px"), "Window Height": (str (OS.get_real_window_size ().y) + "px"),
		"Graphic Resolution size": (str (((4 * OS.window_size.x * OS.window_size.y) / 1024) / 1024) + "MB"),
		"Window Xposition": (str (OS.window_position.x) + "px"), "Window Yposition": (str (OS.window_position.y) + "px"),
		"Window Min Width": (str (OS.min_window_size.x) + "px"), "Window Max Width": (str (OS.max_window_size.x) + "px"),
		"Window Min Height": (str (OS.min_window_size.y) + "px"), "Window Max Height": (str (OS.max_window_size.y) + "px"),
		"FullScreen": OS.window_fullscreen, "VSync": OS.vsync_enabled, "VSync Compositor": OS.vsync_via_compositor,
		"Processor Optimization": OS.low_processor_usage_mode, "Window Borderless": OS.window_borderless, "Keep Screen": OS.keep_screen_on,
		"Window Resizable": OS.window_resizable, "Window Foreground": OS.is_window_always_on_top (), "Window Focused": OS.is_window_focused (),
		"Project ID": OS.get_process_id (), "Idle Frame": Engine.get_idle_frames (), "Frame Draw": Engine.get_frames_drawn (),
		"Pixels Count": int (OS.window_size.x * OS.window_size.y)
	}) if !Engine.editor_hint else Dictionary ({});

"""@Description: Returns usefull computer statistiques."""
static func get_computer_statistiques () -> Dictionary:
	# Return the current computer statistiques.
	return Dictionary ({
		"Batery Percent": OS.get_power_percent_left (), "Video Driver Count": OS.get_video_driver_count (), "Touch Screen": OS.has_touchscreen_ui_hint (),
		"Audio Driver Count": OS.get_audio_driver_count (), "Connected Controller(s)": get_connected_controllers_names ().join (", "),
		"Date System": (str (OS.get_date ().day) + '/' + str (OS.get_date ().month) + '/' + str (OS.get_date ().year)),
		"Time System": (str (OS.get_time ().hour) + "h:" + str (OS.get_time ().minute) + "min:" + str (OS.get_time ().second) + 's'),
		"Memory Usage": OS.get_dynamic_memory_usage (), "Connected Controller Count": get_connected_controllers_names ().size (),
		"Host OS Local": OS.get_locale (), "Model Name": OS.get_model_name (), "OS Name": OS.get_name (), "Screen Size": OS.get_screen_size (),
		"Batery Remaining Time": get_time_from (OS.get_power_seconds_left ()) if OS.get_power_seconds_left () != -1 else "Unknown",
		"Processor Count": OS.get_processor_count (), "Screen Count": OS.get_screen_count (), "Screen DPI": OS.get_screen_dpi (),
		"Screen Max Scale": OS.get_screen_max_scale (), "Static Memory Usage": OS.get_static_memory_usage (),
		"Tablet Driver Count": OS.get_tablet_driver_count (), "Thread Caller ID": OS.get_thread_caller_id (),
		"Time Zone": (str (OS.get_time_zone_info ().bias) + '/' + OS.get_time_zone_info ().name), "Unique ID": OS.get_unique_id (),
	}) if !Engine.editor_hint else Dictionary ({});

"""
	@Description: Displays in real time the different data contained in the parameter data. Call this method on game runtime only.
	@Parameters:
		bool visible: Should we display the data from the debugging ?
		Node object: Which knot will be considered to make the differents operations ?
		Dictionary data: Contains the various data to displayed for debugging.
		Dictionary options: Contains the different configurations for managing the display of data. This dictionary supports the keys following:
			-> bool vspace = false: Do you want add a vertical space on all materialized data ?
			-> int mrgtop = 0: Add a margin in top of the represented data set.
			-> int mrgleft = 0: Add a margin to left of all the data represented.
			-> int mrgright = 0: Add a margin to right of all the data represented.
			-> int mrgbottom = 0: Add a margin in bottom of the set of data represented.
			-> int charcount = -1: characters do you want displayed on all displayed data ?
			-> bool uppercase = false: Would you like capitalize all the represented data ?
			-> Color color = Color.white: Controls the color of all data materialized by debugging.
		Note that you have the possibility of customizing the properties of each data represented. All you have to do is specify the name of the
		key corresponding to the data to be personalized and from it assigned a dictionary supporting the keys: mrgtop, mrgbottom, mrgleft, mrgright,
		color, charcount and uppercase.
		String | Array | PoolStringArray filter: Contains the key (s) of the elements that will be represented during debugging.
		float delay: What is the dead time before materialization data ?
"""
static func debug_data (visible: bool, object: Node, data: Dictionary = Dictionary ({}), options: Dictionary = {}, filter = null, delay: float = 0.0) -> void:
	# The game is running.
	if not Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && not is_game_initialised (): yield (object.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Getting available game control debug node.
		var root: Viewport = object.get_viewport (); var gme_ctrl_dbg = root.get_node_or_null ("game_debug");
		# Getting the vbox container from the debug control.
		var container = gme_ctrl_dbg.get_node_or_null ("container") if gme_ctrl_dbg is Control else null;
		# Check visible value.
		if visible:
			# Converting the filter parameter into an PoolStringArray.
			filter = Array ([filter]) if not is_array (filter) else Array (filter); filter = Array (PoolStringArray (filter));
			# Correct filter value.
			filter = Array ([]) if filter.size () == 1 and filter [0] == "Null" else filter;
			# The game control debug node exists.
			if not gme_ctrl_dbg is Control:
				# Creating a new control node named "game_debug".
				var game_state_contr: Control = Control.new (); game_state_contr.name = "game_debug";
				# Creating a VBoxContainer node named "container".
				var vcontainer: VBoxContainer = VBoxContainer.new (); vcontainer.name = "container";
				# Adding the vbox container to this node as a child and add the final result to root node.
				game_state_contr.add_child (vcontainer); root.add_child (game_state_contr);
				# Updating base nodes.
				gme_ctrl_dbg = root.get_node_or_null ("game_debug"); container = gme_ctrl_dbg.get_node_or_null ("container");
			# Configure VBoxContainer.
			container.alignment = options.align if options.has ("align") && options.align is int else container.alignment;
			container.margin_top = options.mrgtop if options.has ("mrgtop") && options.mrgtop is int else container.margin_top;
			container.margin_right = options.mrgright if options.has ("mrgright") && options.mrgright is int else container.margin_right;
			container.margin_bottom = options.mrgbottom if options.has ("mrgbottom") && options.mrgbottom is int else container.margin_bottom;
			container.margin_left = options.mrgleft if options.has ("mrgleft") && options.mrgleft is int else container.margin_left;
			# Show all data.
			for item in data:
				# Converting the current item as string format.
				var n = (item as String).lstrip (' ').rstrip (' '); var v: String = str_replace (n.replace (' ', '_'), ['.', ':', '@', '/', '"'], '');
				# Getting the current label node.
				var lb: Label = container.get_node_or_null (v);
				# Should us display it ?
				if n in filter || filter.empty ():
					# The current label is not defined.
					if not lb is Label:
						# Contains a label instance.
						var label: Label = Label.new (); label.name = v; container.add_child (label);
						# Update the base pointor.
						lb = container.get_node_or_null (v);
					# Configure label with global keys.
					lb.text = (n + ": " + str (data [item]) + ("\n" if options.has ("vspace") && options.vspace is bool && options.vspace else ''));
					lb.modulate = options.color if options.has ("color") && options.color is Color else lb.modulate;
					lb.visible_characters = options.charcount if options.has ("charcount") && options.charcount is int else -1;
					lb.mouse_filter = Control.MOUSE_FILTER_IGNORE; lb.mouse_default_cursor_shape = Control.CURSOR_ARROW;
					lb.uppercase = options.uppercase if options.has ("uppercase") && options.uppercase is bool else lb.uppercase;
					lb.align = Label.ALIGN_LEFT; lb.valign = Label.VALIGN_TOP; lb.percent_visible = 1;
					# There are a specific property(ies) about the current label.
					if options.has (n):
						# Re-configure label custom values.
						var re: Array = Array ([options [n].has ("mrgleft"), options [n].has ("mrgright"), options [n].has ("mrgtop"), options [n].has ("mrgbottom")]);
						var mrgleft: int = int (options [n].mrgleft if re [0] && options [n].mrgleft is int || re [0] && options [n].mrgleft is float else 0);
						var mrgright: int = int (options [n].mrgright if re [1] && options [n].mrgright is int || re [1] && options [n].mrgright is float else 0);
						var mrgtop: int = int (options [n].mrgtop if re [2] && options [n].mrgtop is int || re [2] && options [n].mrgtop is float else 0);
						var mrgbottom: int = int (options [n].mrgbottom if re [3] && options [n].mrgbottom is int || re [3] && options [n].mrgbottom is float else 0);
						for _j in range (1, mrgleft): lb.text = (' ' + lb.text); for _n in range (1, mrgright): lb.text = (lb.text + ' ');
						for _i in range (1, mrgtop): lb.text = ("\n" + lb.text); for _p in range (1, mrgbottom): lb.text = (lb.text + "\n");
						lb.visible_characters = options [n].charcount if options [n].has ("charcount") && options [n].charcount is int else lb.visible_characters;
						lb.uppercase = options [n].uppercase if options [n].has ("uppercase") && options [n].uppercase is bool else lb.uppercase;
						lb.modulate = options [n].color if options [n].has ("color") && options [n].color is Color else lb.modulate;
				# Otherwise.
				elif lb is Label: lb.queue_free ();
		# Destroy debug control.
		elif gme_ctrl_dbg is Control: gme_ctrl_dbg.queue_free ();
	# Warning message.
	else: _output ("This method must be called on game runtime only.", Message.WARNING);

"""
	@Description: Changes game globals configurations. Call this method on game runtime only.
	@Parameters:
		Dictionary settings: Contains differents options for managing game globals configurations. This dictionary supports the keys following:
			-> int orientation = 0: The screen orientation.
			-> bool broderless = false: Game window borderles.
			-> bool fullscreen = false: Game fullscreen effect.
			-> bool resizable = true: Game window is it resizable ?
			-> Vector2 resolution = Vector2 (1024, 600): Game window size control.
			-> bool foreground = false: Game window should it always on top ?
			-> Vector2 minsize = Vector2 (0, 0): What is the minimum resolution of the game window ? If only one of the values ​​of this vector is negative or zero,
				we will consider that the minimum value of the latter is zero. Don't give a resolution greater than that of the game window.
			-> Vector2 position = Vector2 (-1, -1): What is the position of the window of the Game ? If only one of the values ​​of this vector is negative, the latter
				will be automatically centered on the screen at the value not respecting the conditions of a resolution when the game is run for the first time.
			-> Vector2 maxsize = Vector2 (0, 0): What is the maximum resolution of the game window ? If would be only one of the values ​​of this vector is less than
				the current resolution of the game window, we will consider that the maximum size is equal to the current one within the game window. Do not give
				a resolution higher than this that can support the screen of your machine.
			-> int quality = MegaAssets.GameQuality.LOW: The game quality. The possibles values are:
				MegaAssets.GameGrade.LOW or 0: Low game quality.
				MegaAssets.GameGrade.MEDIUM or 1: Medium game quality.
				MegaAssets.GameGrade.HIGH or 2: High game quality.
			-> float volume: Global game sound volume.
			-> int contrast = 13: The game screen contrast.
			-> int brightness = 13: The game screen brightness.
			-> int saturation = 13: The game screen saturation.
			-> bool vsync = true: See godot documentation about vsync property on OS class.
			-> bool optimization = false: Game proccessor usage optimization.
			-> bool vsyncompositor = false: See godot documentation about vsync_compositor property on OS class.
			-> bool keepscreen = true: Do you want keep computer screen on while the game is playing ?
		Node object: Which knot will be considered to make the differents operations ?
		String | Array | PoolStringArray | NodePath nodes: Contains the different node (s) to targeted for the application of the value of certain
			dictionary keys provided. This parameter supports nodes of type Camara and WorldEnvironment to update the value of properties staturation, quality,
			contrast and brightness; AudioStreamPlayer, AudioStreamPlayer2D and AudioStreamPlayer3D to update the value of properties "volume_db" and "max_db".
		float delay: What is the dead time before the application of configurations ?
"""
static func apply_game_settings (settings: Dictionary, object: Node, nodes = null, delay: float = 0.0) -> void:
	# The game is running.
	if not Engine.editor_hint:
		# Waiting for user delay.
		if delay > 0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Converting the nodes parameter into an PoolStringArray.
		nodes = Array ([nodes]) if !nodes is Array && !nodes is PoolStringArray else nodes;
		# Game window configuration.
		OS.screen_orientation = settings.orientation if settings.has ("orientation") && settings.orientation is int else OS.screen_orientation;
		OS.window_borderless = settings.borderless if settings.has ("borderless") && settings.borderless is bool else OS.window_borderless;
		OS.window_fullscreen = settings.fullscreen if settings.has ("fullscreen") && settings.fullscreen is bool else OS.window_fullscreen;
		OS.window_resizable = settings.resizable if settings.has ("resizable") && settings.resizable is bool else OS.window_resizable;
		var resolution: Vector2 = settings.resolution if settings.has ("resolution") && settings.resolution is Vector2 else OS.window_size;
		resolution.x = 0.0 if resolution.x < 0.0 else resolution.x; resolution.y = 0.0 if resolution.y < 0.0 else resolution.y; OS.window_size = resolution;
		OS.set_window_always_on_top (settings.foreground if settings.has ("foreground") && settings.foreground is bool else OS.is_window_always_on_top ());
		var min_size: Vector2 = settings.minsize if settings.has ("minsize") && settings.minsize is Vector2 else Vector2.ZERO;
		min_size.x = 0.0 if min_size.x < 0.0 else min_size.x; min_size.y = 0.0 if min_size.y < 0.0 else min_size.y;
		min_size.x = OS.get_real_window_size ().x if min_size.x > OS.get_real_window_size ().x else min_size.x;
		min_size.y = OS.get_real_window_size ().y if min_size.y > OS.get_real_window_size ().y else min_size.y;
		var max_size: Vector2 = settings.maxsize if settings.has ("maxsize") && settings.maxsize is Vector2 else OS.get_real_window_size ();
		max_size.x = OS.get_real_window_size ().x if max_size.x < OS.get_real_window_size ().x else max_size.x;
		max_size.x = OS.get_screen_size ().x if max_size.x > OS.get_screen_size ().x else max_size.x;
		max_size.y = OS.get_real_window_size ().y if max_size.y < OS.get_real_window_size ().y else max_size.y;
		max_size.y = OS.get_screen_size ().y if max_size.y > OS.get_screen_size ().y else max_size.y;
		OS.min_window_size = min_size; OS.max_window_size = max_size;
		OS.keep_screen_on = settings.keepscreen if settings.has ("keepscreen") && settings.keepscreen is bool else OS.keep_screen_on;
		OS.vsync_via_compositor = settings.vsyncompositor if settings.has ("vsyncompositor") && settings.vsyncompositor is bool else OS.vsync_via_compositor;
		OS.low_processor_usage_mode = settings.optimization if settings.has ("optimization") && settings.optimization is bool else OS.low_processor_usage_mode;
		OS.vsync_enabled = settings.vsync if settings.has ("vsync") && settings.vsync is bool else OS.vsync_enabled;
		if settings.has ("position") && settings.position is Vector2:
			var win_pos: Vector2 = settings.position;
			if settings.position.x < 0: win_pos.x = ((OS.get_screen_size ().x / 2) - (OS.get_real_window_size ().x / 2));
			if settings.position.y < 0: win_pos.y = ((OS.get_screen_size ().y / 2) - (OS.get_real_window_size ().y / 2));
			OS.window_position = win_pos;
		OS.window_size = Vector2 (1366, 768) if settings.has ("maximize") && settings.maximize is bool && settings.maximize else resolution;
		# External nodes configuration.
		for node in nodes:
			# Filter each item from the node list.
			node = object.get_node_or_null (node) if node is String or node is NodePath else node;
			# The current node is a Camera or WorldEnvirnment.
			if node is WorldEnvironment or node is Camera:
				# Configure a certain propertes.
				var env = node.environment if node.environment != null else null;
				# The current environment variable is not null.
				if env is Environment:
					env.adjustment_enabled = true; env.tonemap_mode = settings.quality if settings.has ("quality") && settings.quality is int else env.tonemap_mode;
					if settings.has ("brightness"): if settings.brightness is float or settings.brightness is int: env.adjustment_brightness = settings.brightness;
					if settings.has ("contrast"): if settings.contrast is float or settings.contrast is int: env.adjustment_contrast = settings.contrast;
					if settings.has ("saturation"): if settings.saturation is float or settings.saturation is int: env.adjustment_saturation = settings.saturation;
			# The current node is audio stream 2d or simple.
			elif node is AudioStreamPlayer or node is AudioStreamPlayer2D:
				# Configure a certain propertes.
				if settings.has ("volume"): if settings.volume is float or settings.volume is int: node.volume_db = linear2db (settings.volume * db2linear (24) / 100);
			# The current node is audio stream 3d.
			elif node is AudioStreamPlayer3D:
				# Configure a certain propertes.
				if settings.has ("volume"): if settings.volume is float or settings.volume is int: node.max_db = linear2db (settings.volume * db2linear (6) / 100);
	# Warning message.
	else: _output ("This method must be called on game runtime only.", Message.WARNING);

"""
	@Description: Returns a certain folders paths from the installed Operating System.
	@Parameters:
		int path: Contains a specified path. The possible values are:
			MegaAssets.Path.GAME_LOCATION or 0: Game location folder.
			MegaAssets.Path.OS_ROOT or 1: Operating system root folder.
			MegaAssets.Path.USER_DATA or 2: The user data folder.
			MegaAssets.Path.USER_ROOT or 3: The user root folder.
			MegaAssets.Path.USER_DESKTOP or 4: The user desktop folder.
			MegaAssets.Path.USER_PICTURES or 5: The user pictures folder.
			MegaAssets.Path.USER_MUSIC or 6: The user musics folder.
			MegaAssets.Path.USER_VIDEOS or 7: The user videos folder.
			MegaAssets.Path.USER_DOCUMENTS or 8: The user documents folder.
			MegaAssets.Path.USER_DOWNLOADS or 9: The user downloads folder.
"""
static func get_os_dir (path: int) -> String:
	# Check the given path enum index.
	if path == Path.GAME_LOCATION: return "res://"; 
	elif path == Path.OS_ROOT && OS.get_name () == "X11" || path == Path.OS_ROOT && OS.get_name () == "OSX": return '/';
	elif path == Path.OS_ROOT && OS.get_name () == "Windows": return "C://"; elif path == Path.USER_DATA: return OS.get_user_data_dir ();
	elif path == Path.USER_ROOT: return "user://"; elif path == Path.USER_DESKTOP: return OS.get_system_dir (OS.SYSTEM_DIR_DESKTOP);
	elif path == Path.USER_PICTURES: return OS.get_system_dir (OS.SYSTEM_DIR_PICTURES);
	elif path == Path.USER_MUSIC: return OS.get_system_dir (OS.SYSTEM_DIR_MUSIC);
	elif path == Path.USER_VIDEOS: return OS.get_system_dir (OS.SYSTEM_DIR_MOVIES);
	elif path == Path.USER_DOCUMENTS: return OS.get_system_dir (OS.SYSTEM_DIR_DOCUMENTS);
	elif path == Path.USER_DOWNLOADS: return OS.get_system_dir (OS.SYSTEM_DIR_DOWNLOADS); else: return "Null";

"""@Description: Watches for window size changes and handles, game screen scaling with exact integer and multiples of a base resolution in mind."""
func pixels_adjusment () -> void:
	# Parse project settings.
	if ProjectSettings.has_setting ("display/window/integer_resolution_handler/base_width"):
		__cash__.base_resolution.x = ProjectSettings.get_setting ("display/window/integer_resolution_handler/base_width");
	if ProjectSettings.has_setting ("display/window/integer_resolution_handler/base_height"):
		__cash__.base_resolution.y = ProjectSettings.get_setting ("display/window/integer_resolution_handler/base_height");
	# Check stretch mode from project settings.
	match ProjectSettings.get_setting ("display/window/stretch/mode"):
		"2d": __cash__.stretch_mode = SceneTree.STRETCH_MODE_2D; "viewport": __cash__.stretch_mode = SceneTree.STRETCH_MODE_VIEWPORT;
		_: __cash__.stretch_mode = SceneTree.STRETCH_MODE_DISABLED;
	# Check stretch aspect from project settings.
	match ProjectSettings.get_setting ("display/window/stretch/aspect"):
		"keep": __cash__.stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP; "keep_height": __cash__.stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP_HEIGHT;
		"keep_width": __cash__.stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP_WIDTH; "expand": __cash__.stretch_aspect = SceneTree.STRETCH_ASPECT_EXPAND;
		_: __cash__.stretch_aspect = SceneTree.STRETCH_ASPECT_IGNORE;
	# Enforce minimum resolution.
	OS.min_window_size = self.__cash__.base_resolution; var root: Viewport = self.get_viewport ();
	# Remove default stretch behavior.
	self.get_tree ().set_screen_stretch (SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, self.__cash__.base_resolution, 1);
	var video_mode: Vector2 = OS.get_screen_size () if OS.window_fullscreen else OS.window_size;
	# Calculate pixels scale.
	var scale: int = int (max (floor (min ((video_mode.x / self.__cash__.base_resolution.x), (video_mode.y / self.__cash__.base_resolution.y))), 1));
	var screen_size: Vector2 = self.__cash__.base_resolution; var viewport_size: Vector2 = (screen_size * scale);
	var overscan: Vector2 = ((video_mode - viewport_size) / scale).floor (); var margin: Vector2; var margin2: Vector2;
	# Re-check stretch aspect.
	match self.__cash__.stretch_aspect:
		SceneTree.STRETCH_ASPECT_KEEP_WIDTH: screen_size.y += overscan.y; SceneTree.STRETCH_ASPECT_KEEP_HEIGHT: screen_size.x += overscan.x;
		SceneTree.STRETCH_ASPECT_EXPAND, SceneTree.STRETCH_ASPECT_IGNORE: screen_size += overscan;
	viewport_size = (screen_size * scale); margin = ((video_mode - viewport_size) / 2); margin2 = margin.ceil (); margin = margin.floor ();
	# Re-check stretch mode.
	match self.__cash__.stretch_mode:
		SceneTree.STRETCH_MODE_VIEWPORT:
			root.set_size ((screen_size / ProjectSettings.get_setting ("display/window/stretch/shrink")).floor ());
			root.set_attach_to_screen_rect (Rect2 (margin, viewport_size)); root.set_size_override_stretch (false); root.set_size_override (false);
		SceneTree.STRETCH_MODE_2D, _:
			root.set_size ((viewport_size / ProjectSettings.get_setting ("display/window/stretch/shrink")).floor ());
			root.set_attach_to_screen_rect (Rect2 (margin, viewport_size)); root.set_size_override_stretch (true);
			root.set_size_override (true, (screen_size / ProjectSettings.get_setting ("display/window/stretch/shrink")).floor ());
	# Check margins value.
	margin.x = 0.0 if margin.x < 0.0 else margin.x; margin.y = 0.0 if margin.y < 0.0 else margin.y;
	margin2.x = 0.0 if margin2.x < 0.0 else margin2.x; margin2.y = 0.0 if margin2.y < 0.0 else margin2.y;
	# Update black bars.
	VisualServer.black_bars_set_margins (int (margin.x), int (margin.y), int (margin2.x), int (margin2.y));

"""
	@Description: Draws a 3d line with the passed data.
	@Parameters:
		Dictionary data: Contains the different configurations on tracing and line behavior. The dictionary supports the keys following:
			-> NodePath | String parent: A plotted line will be the child of which parent? If the value specified is invalid or if there is no value,
				the value in the "object" parameter will be used.
			-> Variant points: Contains the coordinates of different points on which will define the trajectory that the plotted line will take.
				Note that you have the option of giving an instance of a node of type "RayCast".
			-> String id = "LineRenderer": Contains the line name.
			-> int mesh = Mesh.PRIMITIVE_TRIANGLES: What mesh used to draw the line? Note that the possible values ​​are those of Godot.
			-> int fze = MegaAssets.Axis.NONE: Which axis will be froozen ? The possibles values are:
				-> MegaAssets.Axis.NONE or 0: No axis will be froozen.
				-> MegaAssets.Axis.X or 1: freeze x axis.
				-> MegaAssets.Axis.Y or 2: freeze y axis.
				-> MegaAssets.Axis.Z or 3: freeze z axis.
				-> MegaAssets.Axis.XY or 7: freeze xy axis.
				-> MegaAssets.Axis.XZ or 8: freeze xz axis.
				-> MegaAssets.Axis.YZ or 9: freeze yz axis.
				-> MegaAssets.Axis.XYZ or 13: freeze xyz axis.
			-> Color | ShaderMaterial | SpatialMaterial skin = Color.White: Contains the line skin.
			-> bool visible = true: Control the line visibility.
			-> float | Vector2 | int width = 0.004: What is the line width ?
			-> float | Vector2 | int smooth = 5.0: What is the rounding of the corners and caps ?
			-> bool skinscale = false: Do us to increase the scale of enlargement of the complexion loaded currently on the line ?
			-> Dictionary | Array actions: Contains the (s) action (s) to be performed during line design. The use of this parameter is
				already described at the basics of the framework. see "run_slot" method to get more details.
			-> Dictionary oncolliding: Called when the raycast referred detects an object carrying a collider. Only use this key if you give
				at the "points" key, a raycast.
			-> NodePath | String | PoolStringArray impact: Which is/are the path(s) of the object(s) to be set to the position of the point of impact given by
				a raycast ? You also have the possibility to give path(s) pointing to of prefabricated object(s). Use this key only inside "oncolliding" key.
			-> bool destroy = true: Should us destroy the imported prefab object(s) when no object is detected ?
			Note that you have the possibility to use one of the identifiers of an object (the name, the group and the type of class belonging to the object
			detected by a raycast) to change the line behavior.
		Node object: Which knot will be considered to make the differents operations ?
		float live: What is the lifespan of the line after its creation.
		float delay: What is the dead time before line tracing ?
"""
static func draw_line_3d (data: Dictionary, object: Node, live: float = -1.0, delay: float = 0.0) -> void:
	# Live parameter value is different of zero.
	if live != 0.0:
		# The game is running.
		if !Engine.editor_hint:
			# If the game is not initialised.
			if delay == 0.0 && !is_game_initialised (): yield (object.get_tree (), "idle_frame");
			# Otherwise.
			elif delay > 0.0: yield (object.get_tree ().create_timer (delay), "timeout");
		# Check parent key.
		data.parent = (data.parent if data.parent is String || data.parent is NodePath else object.get_path ()) if data.has ("parent") else object.get_path ();
		# Getting the real parent reference.
		data.parent = object.get_node_or_null (data.parent); data.points = data.points if data.has ("points") else null;
		# Convert the passed points into an array.
		data.points = Array ([data.points]) if !is_array (data.points) else (Array (data.points) if len (data.points) > 0 else Array ([null]));
		# Getting the given node from points array.
		var raycast = object.get_node_or_null (data.points [0]) if data.points [0] is String or data.points [0] is NodePath else data.points [0];
		# Check whether the current point is a RayCast.
		data.parent = raycast if raycast is RayCast else data.parent;
		# The parent is it a 3d node ?
		if data.parent is Spatial:
			# Getting the passed line id.
			data.id = str_replace (data.id, ['.', ':', '@', '/', '"'], '').lstrip (' ').rstrip (' ') if data.has ("id") && data.id is String else ("LineRenderer");
			# Getting the existing immediate geometry.
			var geometry = data.parent.get_node_or_null (data.id);
			# Is it visible ?
			if (data.visible if data.has ("visible") && data.visible is bool else true):
				# Immediate geomety node don't exists.
				if not geometry is ImmediateGeometry:
					# Creating a new geometry from the given id.
					var geo: ImmediateGeometry = ImmediateGeometry.new (); geo.name = data.id;
					# Add this node to the given parent and update geometry variable.
					data.parent.add_child (geo); geometry = data.parent.get_node_or_null (data.id);
					# Sets geometry position to his parent position.
					geometry.transform.origin = Vector3.ZERO; _destroy_geometry_after_live (live, geometry, object);
				# A raycast has been passed.
				if data.parent is RayCast:
					# Contains the raycast points data.
					var ray_pts: PoolVector3Array = PoolVector3Array ([Vector3.ZERO, data.parent.cast_to]);
					# Initializing geometry.
					data = _run_line_common_configs (data, Dictionary ({}), geometry, ray_pts, object);
					# Is it colliding ?
					if data.parent.is_colliding ():
						# Update the collision point of the ray.
						ray_pts [1] = geometry.to_local (data.parent.get_collision_point ()); var collider = data.parent.get_collider ();
						# Update line geometry to raycast collision point.
						data = _run_line_common_configs (data, Dictionary ({}), geometry, ray_pts, object);
						# "oncolliding" key is it correct ?
						if data.has ("oncolliding") && data.oncolliding is Dictionary && !data.oncolliding.empty ():
							# Updating colliding configurations.
							data.oncolliding = _run_line_common_configs (data.oncolliding, data, geometry, ray_pts, object);
							# Getting from the collider a useful informations.
							var re: Array = Array ([collider.name, collider.get_class (), collider.get_groups ()]);
							# The current detected object has a valid name.
							if data.oncolliding.has (re [0]) && data.oncolliding [re [0]] is Dictionary && !data.oncolliding [re [0]].empty ():
								# Run the given configurations.
								data.oncolliding [re [0]] = _run_line_common_configs (data.oncolliding [re [0]], data.oncolliding, geometry, ray_pts, object);
								# Run all given actions.
								_run_line_ray_common_configs (data.oncolliding [re [0]], data.parent, geometry, object);
							# The current detected object is found.
							elif data.oncolliding.has (re [1]) && data.oncolliding [re [1]] is Dictionary && !data.oncolliding [re [1]].empty ():
								# Run the given configurations.
								data.oncolliding [re [1]] = _run_line_common_configs (data.oncolliding [re [1]], data.oncolliding, geometry, ray_pts, object);
								# Run all given actions.
								_run_line_ray_common_configs (data.oncolliding [re [1]], data.parent, geometry, object);
							# The collider has a group.
							elif not re [2].empty ():
								# Ckeck whether an id is found.
								var found_id: bool = false;
								# Search the main group name.
								for id in re [2]:
									# The target group name has been found.
									if data.oncolliding.has (id) && data.oncolliding [id] is Dictionary && !data.oncolliding [id].empty ():
										# Run the given configurations.
										data.oncolliding [id] = _run_line_common_configs (data.oncolliding [id], data.oncolliding, geometry, ray_pts, object);
										# Run all given actions.
										_run_line_ray_common_configs (data.oncolliding [id], data.parent, geometry, object); found_id = true; break;
								# Is it found an id ?
								if not found_id: _run_line_ray_common_configs (data.oncolliding, data.parent, geometry, object);
							# On colliding scope.
							else: _run_line_ray_common_configs (data.oncolliding, data.parent, geometry, object);
					# No collision found.
					else: _run_line_ray_common_configs (data, null, geometry, object);
				# Otherwise.
				else: data = _run_line_common_configs (data, Dictionary ({}), geometry, data.points, object);
			# Destroy the existing immediate geometry.
			elif geometry is ImmediateGeometry: geometry.queue_free ();
		# Error message.
		else: _output ("The parent node must be an instance of Spatial.", Message.ERROR);

"""
	@Description: Draws a line with the passed points.
	@Parameters:
		bool show: Do you want to show final result ?
		String id: Contains the line name.
		Spatial | NodePath | String | Vector2 | Vector3 | PoolVector2Array | PoolVector3Array | Array | PoolStringArray pts: Contains all points to used to draw the line.
		Spatial parent: Where do you want to draw the line ?
		Color color: Contains the line color.
		int fze: Which axis will be froozen ? The possibles values are:
			-> MegaAssets.Axis.NONE or 0: No axis will be froozen.
			-> MegaAssets.Axis.X or 1: freeze x axis.
			-> MegaAssets.Axis.Y or 2: freeze y axis.
			-> MegaAssets.Axis.Z or 3: freeze z axis.
			-> MegaAssets.Axis.XY or 7: freeze xy axis.
			-> MegaAssets.Axis.XZ or 8: freeze xz axis.
			-> MegaAssets.Axis.YZ or 9: freeze yz axis.
			-> MegaAssets.Axis.XYZ or 13: freeze xyz axis.
		int mesh: Wich mesh used to draw the line ? The possibles values are:
			-> Mesh.PRIMITIVE_LINES or 1: Render array as lines (every two vertices a line is created).
			-> Mesh.PRIMITIVE_LINE_STRIP or 2: Render array as line strip.
			-> Mesh.PRIMITIVE_LINE_LOOP or 3: Render array as line loop (like line strip, but closed).
		float delay: The dead time before drawing line.
"""
static func debug_line_3d (show: bool, id: String, pts, parent: Spatial, color: Color = Color.black, fze: int = Axis.NONE, mesh: int = 2, delay: float = 0.0) -> void:
	# The game is running.
	if !Engine.editor_hint:
		# If the game is not initialised.
		if delay == 0.0 && !is_game_initialised (): yield (parent.get_tree (), "idle_frame");
		# Otherwise.
		elif delay > 0.0: yield (parent.get_tree ().create_timer (delay), "timeout");
	# Getting the existing immediate geometry.
	id = str_replace (id, PoolStringArray (['.', ':', '@', '/', '"']), '').lstrip (' ').rstrip (' '); var geometry = parent.get_node_or_null (id);
	# Is it visible.
	if show:
		# Converting points parameters into an array.
		pts = Array ([pts]) if !pts is Array && !pts is PoolVector2Array && !pts is PoolVector3Array else pts;
		# The mesh value is less than 1.
		mesh = Mesh.PRIMITIVE_LINES if mesh <= Mesh.PRIMITIVE_LINES else mesh;
		# The mesh value is greather than 3.
		mesh = Mesh.PRIMITIVE_LINE_LOOP if mesh >= Mesh.PRIMITIVE_LINE_LOOP else mesh;
		# Immediate geomety node don't exists.
		if not geometry is ImmediateGeometry:
			# Creating a new geometry from the given id.
			var geo: ImmediateGeometry = ImmediateGeometry.new (); geo.name = id;
			# Add this node to the given parent and update geometry variable.
			parent.add_child (geo); geometry = parent.get_node_or_null (id);
			# Sets geometry position to his parent position.
			geometry.transform.origin = Vector3.ZERO;
		# Create a new spatial material fill the line.
		var colour: SpatialMaterial = SpatialMaterial.new (); colour.albedo_color = color; geometry.material_override = colour;
		# Initializing geometry.
		geometry.clear (); geometry.begin (mesh);
		# Adding each point a immediate geometry after clearing of the preview data.
		for pt in pts:
			# Drawing the current point.
			pt = _get_real_point_cords (fze, pt, parent); if pt != null: geometry.add_vertex (pt);
		# End the drawing sequence.
		geometry.end ();
	# Destroy the existing immediate geometry.
	elif geometry is ImmediateGeometry: geometry.queue_free ();

"""
	@Description: Draws a ray with the passed points.
	@Parameters:
		bool show: Do you want to show final result ?
		String id: Contains the ray name.
		Vector2 | Vector3 | Spatial | NodePath | String start: Contains the start point.
		Vector2 | Vector3 | Spatial | NodePath | String end: Contains the stop point.
		Spatial parent: Where do you want to draw the ray ?
		Color color: Contains the line color.
		int fze: which axis will be froozen ? The possibles values are:
			-> MegaAssets.Axis.NONE or 0: No axis will be froozen.
			-> MegaAssets.Axis.X or 1: freeze x axis.
			-> MegaAssets.Axis.Y or 2: freeze y axis.
			-> MegaAssets.Axis.Z or 3: freeze z axis.
			-> MegaAssets.Axis.XY or 7: freeze xy axis.
			-> MegaAssets.Axis.XZ or 8: freeze xz axis.
			-> MegaAssets.Axis.YZ or 9: freeze yz axis.
			-> MegaAssets.Axis.XYZ or 13: freeze xyz axis.
		float delay: The dead time before drawing ray.
"""
static func debug_ray_3d (show: bool, id: String, start, end, parent: Spatial, color: Color = Color.black, fze: int = Axis.NONE, delay: float = 0.0) -> void:
	# Just draw a line with start and end points.
	debug_line_3d (show, id, Array ([start, end]), parent, color, fze, Mesh.PRIMITIVE_LINE_STRIP, delay);

"""
	@Description: Determinates whether an input is a number (integer or real).
	@Parameters:
		Variant input: Contains an input.
"""
static func is_number (input) -> bool:
	# The imput is an integer or a real.
	if input is int || input is float: return true;
	# The input is a string.
	elif input is String:
		# Contains the real type value of the given string.
		var real_value = get_variant (input); return real_value is int or real_value is float;
	# Otherwise.
	else: return false;

"""
	@Description: Determinates whether an input is a vector (Vector2 or Vector3).
	@Parameters:
		Variant input: Contains an input.
"""
static func is_vector (input) -> bool:
	# The given input is a Vector2 or Vector3.
	if input is Vector2 or input is Vector3: return true;
	# The input is a PoolIntArray, PoolRealArray or PoolByteArray.
	elif input is PoolIntArray or input is PoolRealArray or input is PoolByteArray: return is_range (float (input.size ()), 2.0, 3.0);
	# The given input is a Array.
	elif input is Array && is_range (float (input.size ()), 2.0, 3.0) && is_number (input [0]) && is_number (input [1]):
		# Return the final result.
		return input.size () == 2 || input.size () == 3 && is_number (input [2]);
	# The input is a string.
	elif input is String:
		# Contains the real type value of the given string.
		var real_value = get_variant (input); return !real_value is String and is_vector (real_value);
	# Otherwise.
	else: return false;

"""
	@Description: Subdivides a path represented by several points of the space in sub-small points of the space each of which belongs
		to the trajectory represented by the original points.
	@Parameters:
		Array | PoolVector2Array | PoolVector3Array points: Contains the set of points representing any path.
		int count: The different segments formed by the original points will be subdivided into how many sub-segments ?
"""
static func split_vector3_path (points, count: int):
	# Convert the passed points into an array.
	points = Array ([points]) if !is_array (points) else Array (points);
	# The count is greather than 1.
	if count > 1 and points.size () > 1:
		# Contains the final result.
		var results: PoolVector3Array = PoolVector3Array ([]);
		# Calculate subdivision.
		for j in range (len (points) - 1):
			# Correct the current point and the next point.
			points [j] = any_to_vector3 (points [j]); points [(j + 1)] = any_to_vector3 (points [(j + 1)]);
			# Check points type.
			if points [j] is Vector3 and points [(j + 1)] is Vector3:
				# Contains the distance between two points.
				var global_distance: float = points [j].distance_to (points [(j + 1)]);
				# Contains the distance of each subdivision.
				var sub_distance: float = (global_distance / count); var current_distance: float = 0.0;
				# Calculate all sub points coordonnates.
				while current_distance <= global_distance:
					# Is it the first element of the array ?
					if current_distance == 0.0 and (j - 1) < 0: results.append (points [j]);
					# Is it the last element of the array ?
					elif current_distance == global_distance: results.append (points [(j + 1)]);
					# Otherwise.
					elif current_distance > 0.0:
						# Calculate the current sub point coordinates.
						var x: float = ((current_distance * (points [(j + 1)].x - points [j].x)) + points [j].x);
						var y: float = ((current_distance * (points [(j + 1)].y - points [j].y)) + points [j].y);
						var z: float = ((current_distance * (points [(j + 1)].z - points [j].z)) + points [j].z);
						# Adds the points to existing results.
						results.append (Vector3 (x, y, z));
					# Increase the current distance for the next point.
					current_distance += sub_distance;
			# Error message.
			else: _output ("Can't generate the splited vectors path.", Message.ERROR);
		# Return the final result.
		return results;
	# Otherwise.
	else: return points;

"""
	@Description: Converts an input into Vector2.
	@Parameters:
		Variant input: Contains an input.
"""
static func any_to_vector2 (input):
	# The input is a Vector2 or Vector3.
	if input is Vector2 or input is Vector3: return Vector2 (input.x, input.y);
	# The input is a PoolIntArray, PoolRealArray or PoolByteArray.
	elif input is PoolIntArray or input is PoolRealArray or input is PoolByteArray:
		# The input size is equal to 2 or 3.
		if is_range (float (input.size ()), 2.0, 3.0): return Vector2 (float (input [0]), float (input [1])); else: return null;
	# The given input is a Array.
	elif input is Array && is_range (float (input.size ()), 2.0, 3.0) && is_number (input [0]) && is_number (input [1]):
		# Return the final result.
		return Vector2 (float (input [0]), float (input [1]));
	# The input is a String.
	elif input is String:
		# Contains the real type value of the given string.
		var real_value = get_variant (input); return any_to_vector2 (real_value) if not real_value is String else null;
	# Otherwise.
	else: return null;

"""
	@Description: Converts an input into Vector3.
	@Parameters:
		Variant input: Contains an input.
"""
static func any_to_vector3 (input):
	# The input is a Vector2 or Vector3.
	if input is Vector3: return input; elif input is Vector2: return Vector3 (input.x, input.y, 0.0);
	# The input is a PoolIntArray, PoolRealArray or PoolByteArray.
	elif input is PoolIntArray or input is PoolRealArray or input is PoolByteArray:
		# Check whether input size is equal to 2.
		if input.size () == 2: return Vector3 (float (input [0]), float (input [1]), 0.0);
		# Check whether input size is equal to 3.
		elif input.size () == 3: return Vector3 (float (input [0]), float (input [1]), float (input [2])); else: return null;
	# The given input is a Array.
	elif input is Array && is_range (float (input.size ()), 2.0, 3.0) && is_number (input [0]) && is_number (input [1]):
		# The input size is equal to 2.
		if input.size () == 2: return Vector3 (float (input [0]), float (input [1]), 0.0);
		# Check whether input size is equal to 3.
		elif is_number (input [2]): return Vector3 (float (input [0]), float (input [1]), float (input [2])); else: return null;
	# The input is a String.
	elif input is String:
		# Contains the real type value of the given string.
		var real_value = get_variant (input); return any_to_vector3 (real_value) if not real_value is String else null;
	# Otherwise.
	else: return null;

"""
	@Description: Generates a PoolBytesArray. This method can be useful for key generation.
	@Parameters:
		int size: Contains the PoolByteArray size.
"""
static func rand_bytes (size: int) -> PoolByteArray:
	# The bytes array size is greather than 0.
	if size > 0:
		# Generate a bytes array.
		var bytes = PoolByteArray ([]); for _i in range (size): bytes.append (randi () % 256); return bytes;
	# Otherwise.
	else: return PoolByteArray ([]);

"""
	@Description: Replaces one or more character(s) with one or several other character(s).
	@Parameters:
		String string: Contains the string value.
		String | PoolStringArray what: What is/are the character(s) that will be replaced ?
		String | PoolStringArray to: What is/are the character(s) that will take the place of the designated character(s) ?
		String | int start: From which character or position the replacements will be made ?
		String | int end: What character or position the replacements will stop ?
"""
static func str_replace (string: String, what, to, start = -1, end = -1) -> String:
	# Convert "what" parameter into a PoolStringArray.
	what = Array ([what]) if not is_array (what) else Array (what); what = PoolStringArray (what);
	# Convert "to" parameter into a PoolStringArray.
	to = Array ([to]) if not is_array (to) else Array (to); to = PoolStringArray (to);
	# Convert "start" parameter into an integer.
	start = int (start) if is_number (start) else (string.find (start) if start is String else 0);
	# Convert "end" parameter into an integer.
	end = int (end) if is_number (end) else (string.find (end) if end is String else (len (string) - 1));
	# Correct the start and end value.
	start = start if is_range (start, 0, (len (string) - 1)) else 0; end = end if is_range (end, start, (len (string) - 1)) else (len (string) - 1);
	# Correct asignment or the start value is equal to the end value.
	if start == 0 and end == (len (string) - 1):
		# Start replacing each character to each other.
		for k in what.size ():
			# Replace the current string into "what" array to other string into "to" array.
			if !what [k].empty (): string = string.replace (what [k], to [k]) if k < len (to) else string.replace (what [k], to [(len (to) - 1)]);
	# Otherwise.
	else:
		# Replace the current string into "what" array to other string into "to" array.
		for k in what.size (): for x in range (start, end): string [x] = (to [k] if k < len (to) else to [(len (to) - 1)]) if string [x] == what [k] else string [x];
	# Return the final with replacement(s).
	return string;

"""
	@Description: Removes characters on the left and right from a string.
	@Parameters:
		String string: Contains the string value.
		String | PoolStringArray what_left: What is/are the character(s) to be deleted to the left of the given character string ?
		String | PoolStringArray what_right: What is/are the character(s) to be deleted to the right of the given character string ?
"""
static func str_lrstrip (string: String, what_left = '', what_right = '') -> String:
	# Convert "what_left" parameter into a PoolStringArray.
	what_left = Array ([what_left]) if not is_array (what_left) else Array (what_left); what_left = PoolStringArray (what_left);
	# Convert "what_right" parameter into a PoolStringArray.
	what_right = Array ([what_right]) if not is_array (what_right) else Array (what_right); what_right = PoolStringArray (what_right);
	# Start removing each character from the left string.
	for k in what_left.size (): if !what_left [k].empty (): string = string.lstrip (what_left [k]);
	# Start removing each character from the right string.
	for y in what_right.size (): if !what_right [y].empty (): string = string.rstrip (what_right [y]);
	# Return the final with replacement(s).
	return string;

"""
	@Description: Returns the corresponding option position about "Format" enumeration of Godot Image class.
	@Parameters:
		int option: Contains an option position of "MegaAssets.ImageFormat" enumeration.
"""
static func get_real_image_format (option: int) -> int:
	# Apply all supported format.
	if option <= ImageFormat.RH: option = Image.FORMAT_RH; elif option == ImageFormat.RF: option = Image.FORMAT_RF;
	elif option == ImageFormat.RGH: option = Image.FORMAT_RGH; elif option == ImageFormat.RGF: option = Image.FORMAT_RGF;
	elif option == ImageFormat.RGBH: option = Image.FORMAT_RGBH; elif option == ImageFormat.RGBF: option = Image.FORMAT_RGBF;
	elif option == ImageFormat.RGBAH: option = Image.FORMAT_RGBAH; elif option == ImageFormat.RGBAF: option = Image.FORMAT_RGBAF;
	elif option == ImageFormat.RGBA4444: option = Image.FORMAT_RGBA4444; elif option == ImageFormat.RGBA5551: option = Image.FORMAT_RGBA5551;
	else: option = Image.FORMAT_RGBE9995; return option;

"""
	@Description: Returns the corresponding option position about "CompressMode" enumeration of Godot Image class.
	@Parameters:
		int option: Contains an option position of "MegaAssets.ImageCompression" enumeration.
"""
static func get_real_image_compression (option: int) -> int: return 3 if option == 1 else (4 if option == 2 else (0 if option >= 3 else -1));

"""
	@Description: Returns all data from the created screenshot from the active camera.
	@Parameters:
		Node object: Which knot will be considered to make the differents operations ?
		Dictionary data: Contains the different configurations to be made on the capture, once generated. For more information, consult the documentation
			about "get_screen_shot ()" method.
"""
static func get_screen_shot_data (object: Node, data: Dictionary = Dictionary ({})) -> Array:
	# Returns the generated game screenshot data.
	return Array ((get_screen_shot (object, data) as Texture).get_data ().get_data ());

"""
	@Description: Loads the contents of an extension file (.csv).
	@Parameters:
		String path: Contains the path pointing to the csv file to loaded.
		String separator: What string should we use to distinguish between different data in csv file ?
"""
static func load_csv_file (path: String, separator: String = ',') -> Array:
	# Corrects path separator and removes all spaces.
	path = path.replace ('\\', '/').replace (' ', '');
	# If path value is not empty.
	if path != null and not path.empty ():
		# Checks path value.
		if path.find_last ('.') != -1:
			# Checks csv file extension.
			if path.ends_with (".csv"):
				# Contains the file name.
				var fname: String = path.get_file (); var res: Array = Array ([]);
				# Contains the csv file reference.
				var csv_file: File = File.new (); var index: int = 0;
				# Opens the given csv file.
				if csv_file.open (path, File.READ) == OK:
					# Gets the first line of the opened csv file.
					var line: String = csv_file.get_line ();
					# We aren't at the end of the csv file.
					while not line.empty ():
						# Splits the current line.
						var sp: PoolStringArray = line.split (separator);
						# The line count is null.
						if index == 0:
							# Initializes all available languages.
							for k in range (1, sp.size ()): if not sp [k].empty (): res.append (Dictionary ({sp [k]: Dictionary ({})}));
						# Otherwise.
						else:
							# A key has been donated.
							if sp.size () > 0 and not sp [0].empty ():
								# Getting the associate colonne value.
								for j in range (res.size ()):
									# Some data has been detected.
									var cur = (j + 1); if cur < sp.size (): res [j] [res [j].keys () [0]] [sp [0]] = (sp [cur] if not sp [cur].empty () else "Null");
									# No data found.
									else: res [j] [res [j].keys () [0]] [sp [0]] = "Null";
						# Go to the next line and increase the current line count.
						line = csv_file.get_line (); index += 1;
					# Returns the final result.
					csv_file.close (); return res;
				# Warning message.
				else: _output (("Failed to load {" + fname + "}."), Message.WARNING);
			# Error message.
			else: _output ("The extension of the csv file must be (.csv) format.", Message.ERROR);
		# Warning message.
		else: _output ("The csv file is not defined.", Message.WARNING);
	# Warning message.
	else: _output ("The path is not defined.", Message.WARNING); return Array ([]);

"""
	@Description: Opens the documentation associated with the class in question.
	@Parameters:
		Node object: Which node will be considered to perform the different operations ?
		String feature: The documentation will target which functionality of style ?
		float delay: What is the downtime before the opening of the documentation ?
"""
static func open_doc (object: Node, feature: String = '', delay: float = 0.0) -> void:
	# Waiting for the user delay.
	if delay > 0.0 and !Engine.editor_hint: yield (object.get_tree ().create_timer (delay), "timeout");
	# Open the default user browser with the class documentation path.
	if OS.shell_open (get_source () + (('#' + feature.lstrip ('(').rstrip ('(').lstrip (')').rstrip (')')) if not feature.empty () else '')) != OK: pass;
