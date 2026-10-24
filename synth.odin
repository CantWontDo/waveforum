package main

import "core:fmt"
import "core:math"
import "base:runtime"
import rl "vendor:raylib"
import os "core:os"

import slog "sokol/log"
import saudio "sokol/audio"

offset : f32 = 0.0
offset2 : f32 = 0.0
offset3 : f32 = 0.0
playing := true

stream_buffer :: proc "c" (buffer: ^f32, num_frames: i32, num_channels: i32)
{
	context = runtime.default_context()
	frequency := f32(200.0);
	buffer_ptr : [^]f32 = buffer;
	input_signal : []f32 = make([]f32, num_frames * num_channels)
	defer delete(input_signal)

	convolution := []f32{}

	for i in 0..<num_frames
	{
		val: f32 = 0
		val = math.sin_f32(offset) * 0.3
		offset += 2.0 * math.PI * frequency / 44100
		buffer_ptr[i] = val
	} 

	// filters
	/*
	for i in 0..<num_frames 
	{
		for val, idx in convolution
		{
			if i >= i32(idx)
			{
				buffer_ptr[i] += val * input_signal[i - i32(idx)]
			}
			else 
			{
				buffer_ptr[i] = 0
			}
		}
	}
	*/
}

main :: proc()
{
	saudio.setup({logger = {func = slog.func}, sample_rate = 44100, num_channels = 1, stream_cb = stream_buffer})

	data, read_err := os.read_entire_file("test.mid", context.allocator)
	if read_err != nil
	{
		fmt.println("Couldn't load test.mid!")
		return
	}
	defer delete(data);

	tag := string(data[0:4])

	rl.InitWindow(1280, 720, "waveforum")
	for !rl.WindowShouldClose()
	{
		// playing = rl.IsKeyDown(.RIGHT)
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		rl.EndDrawing()
	}

	rl.CloseWindow()	
	saudio.shutdown()
}

