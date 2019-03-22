package;

import fraggraph.FragGraph;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static function update(): Void {

	}

	static function render(frames: Array<Framebuffer>): Void {

	}

	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {
			new FragGraph();
		});
	}
}
