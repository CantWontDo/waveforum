package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

import slog "sokol/log"
import saudio "sokol/audio"

offset : f32 = 0.0
offset2 : f32 = 0.0
offset3 : f32 = 0.0
playing := true

stream_buffer :: proc "c" (buffer: ^f32, num_frames: i32, num_channels: i32)
{
	frequency : f32 = 220
	frequency2 : f32 = 261.63
	frequency3 : f32 = 329.63
	buffer_ptr : [^]f32 = buffer;
	for i in 0..<num_frames
	{
		val: f32 = 0
		if playing
		{
			val = math.sin_f32(offset) * 0.3 + math.sin_f32(offset2) * 0.3 + math.sin_f32(offset3) * 0.3

			offset += 2.0 * math.PI * frequency / 44100 
			offset2 += 2.0 * math.PI * frequency2 / 44100 
			offset3 += 2.0 * math.PI * frequency3 / 44100 
			if (offset > 2.0 * math.PI) {
				offset = 0.0
			}
			 if (offset2 > 2.0 * math.PI) {
				offset2 = 0.0
			}
			if (offset3 > 2.0 * math.PI) {
				offset3 = 0.0
			} 
		}

		buffer_ptr[i] = val
	} 
}

main :: proc()
{
	saudio.setup({logger = {func = slog.func}, sample_rate = 44100, num_channels = 1, stream_cb = stream_buffer})
	rl.InitWindow(1280, 720, "waveforum")
	for !rl.WindowShouldClose()
	{
		playing = rl.IsKeyDown(.RIGHT)
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		rl.EndDrawing()
	}

	rl.CloseWindow()	
	saudio.shutdown()
}

