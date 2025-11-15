# File: uuid.gd
# You can make this an autoload (singleton) for easy access.

extends Node
class_name UUID

static func v4() -> String:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var bytes := PackedByteArray()
	bytes.resize(16)

	# Fill with random bytes
	for i in range(16):
		bytes[i] = rng.randi_range(0, 255)

	# Set version (4) -> high nibble of byte 6
	bytes[6] = (bytes[6] & 0x0F) | 0x40

	# Set variant (10xx) -> high bits of byte 8
	bytes[8] = (bytes[8] & 0x3F) | 0x80

	# Convert to hex string
	var hex := ""
	for i in range(16):
		hex += "%02x" % bytes[i]

	# 8-4-4-4-12 format
	return "%s-%s-%s-%s-%s" % [
		hex.substr(0, 8),
		hex.substr(8, 4),
		hex.substr(12, 4),
		hex.substr(16, 4),
		hex.substr(20, 12),
	]
