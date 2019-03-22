package fraggraph;

import kha.graphics4.StencilAction;
import kha.graphics4.PipelineState;
import fraggraph.NodeTypes.SecondaryMathNodeTypes;
import haxe.rtti.XmlParser;
import haxe.rtti.Rtti;
import fraggraph.NodeTypes.VectorMathNodeType;
import zui.Nodes.TNode;
import kha.input.KeyCode;
import kha.input.Keyboard;
import fraggraph.NodeTypes.MathNodeType;
import kha.input.Mouse;
import kha.*;
import zui.*;
import zui.Nodes.TNodeCanvas;
import fraggraph.NodeTypes.*;

class FragGraph {
	var graph:Nodes;
	var ui:Zui;
	var controlIsDown:Bool = false;
	var meshButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Mesh");
	var meshNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Mesh",false);

	var outputButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Output");
	var outputNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Output",false);
	
	var textureButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Texture");
	var textureNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Texture",false);
	
	var valueButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Value");
	var valueNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Value",false);
	
	var mathButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Math");
	var mathNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Math",false);
	
	var vectorButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Vector");
	var vectorNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Vector",false);
	
	var colorButtons:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Color");
	var colorNames:Array<String> = MacroUtil.getNodeNames(NodeTypes, "Color",false);

	var grid:Image;
	var outputImage:Image;
	var oldX:Int = 0;
	var oldY:Int = 0;

	// static var nodeNames:Array<String>  = getNodeNames();
	// static macro function getNodeNames(){
	// }
	public function new() {
		Assets.loadEverything(onAssetsDone);
	}

	function appWidth():Int {
		return kha.System.windowWidth(0);
	}

	function appHeight():Int {
		return kha.System.windowHeight(0);
	}

	function onAssetsDone() {
		kha.System.notifyOnFrames(render);
		kha.Scheduler.addTimeTask(function() {
			update();
		}, 0, 1 / 60);
		graph = new Nodes();
		ui = new Zui({font: Assets.fonts.DroidSans, color_wheel: Assets.images.color_wheel});
		Keyboard.get(0).notify(function(k) {
			if (k == KeyCode.Delete && graph.nodeSelected != null && graph.nodeSelected.type != "MATERIAL_OUTPUT") {
				graph.removeNode(graph.nodeSelected, canvas);
			}
			if (k == KeyCode.Control) {
				controlIsDown = true;
			}
			if (graph.nodeSelected != null &&
					graph.nodeSelected.type != "MATERIAL_OUTPUT" &&
					controlIsDown &&
					k == KeyCode.C) {
				NodeTypes.CopyToBufferNode(graph.nodeSelected);
			}
			if (controlIsDown && k == KeyCode.V) {
				NodeTypes.PasteFromBufferNode(graph, canvas);
			}

			if (k == KeyCode.Insert)
				GraphParser.parseToGLSL(canvas);
		}, (k) -> {
				if (k == KeyCode.Control) {
					controlIsDown = false;
				}
			},(s) -> {});

		drawGrid();
		outputImage = Image.createRenderTarget(300, 300);

		pushNode(NodeTypes.createSurfaceNode(graph, canvas));
	}

	function onSizeChanged(x, y):Void {
		if (grid != null)
			grid.unload();
		drawGrid();
	}

	function pushNode(n:TNode):Void {
		if (n != null) {
			n.x = -graph.panX + appWidth() / 2;
			n.y = -graph.panY + appHeight() / 2;
			canvas.nodes.push(n);
			graph.nodeSelected = n;
		}
	}

	public function drawGrid() {
		var w = appWidth() + 40 * 2;
		var h = appHeight() + 40 * 2;
		grid = kha.Image.createRenderTarget(w, h);
		grid.g2.begin(true, 0xff141414);
		for (i in 0...Std.int(h / 40) + 1) {
			grid.g2.color = 0xff303030;
			grid.g2.drawLine(0, i * 40, w, i * 40);
			grid.g2.color = 0xff202020;
			grid.g2.drawLine(0, i * 40 + 20, w, i * 40 + 20);
		}
		for (i in 0...Std.int(w / 40) + 1) {
			grid.g2.color = 0xff303030;
			grid.g2.drawLine(i * 40, 0, i * 40, h);
			grid.g2.color = 0xff202020;
			grid.g2.drawLine(i * 40 + 20, 0, i * 40 + 20, h);
		}
		grid.g2.end();
	}

	function render(framebuffer:Array<Framebuffer>):Void {
		var g = framebuffer[0].g2;

		g.begin();
		g.drawImage(grid, 0, 0);
		g.end();

		ui.begin(g);

		if (ui.window(Id.handle(), 0, 0, appWidth(), appHeight())) {
			graph.nodeCanvas(ui, canvas);
		}

		if (ui.window(Id.handle(), 0, 0, 200, appHeight(), true)) {
			ui.text("Nodes", Left, 0);
			ui.separator();
			// if (ui.panel(Id.handle(), "Output", 0, true)) {
			// 	for (button in outputButtons) {
			// 		if (ui.button(button)) {
			// 			pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, button), [graph, canvas]));
			// 		};
			// 	}
			// }
			if (ui.panel(Id.handle(), "Mesh", 0, true)) {
				for (i in 0...meshButtons.length) {
					if (ui.button(meshNames[i])) {
						pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, meshButtons[i]), [graph, canvas]));
					};
				}
			}
			if (ui.panel(Id.handle(), "Texture", 0, true)) {
				for (i in 0...textureButtons.length) {
					if (ui.button(textureNames[i])) {
						pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, textureButtons[i]), [graph, canvas]));
					};
				}
			}
			if (ui.panel(Id.handle(), "Color", 0, true)) {
				for (i in 0...colorButtons.length) {
					if (ui.button(colorNames[i])) {
						pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, colorButtons[i]), [graph, canvas]));
					};
				}
			}
			if (ui.panel(Id.handle(), "Math", 0, true)) {
				if (ui.button(Add)) {
					pushNode(NodeTypes.createMathNode(graph, canvas, Add));
				};
				else if (ui.button(Subtract)) {
					pushNode(NodeTypes.createMathNode(graph, canvas, Subtract));
				};
				else if (ui.button(Multiply)) {
					pushNode(NodeTypes.createMathNode(graph, canvas, Multiply));
				};
				else if (ui.button(Divide)) {
					pushNode(NodeTypes.createMathNode(graph, canvas, Divide));
				};
				else if (ui.button(DotProduct)) {
					pushNode(NodeTypes.createVectorMathNode(graph, canvas, DotProduct));
				};
				else if (ui.button(CrossProduct)) {
					pushNode(NodeTypes.createVectorMathNode(graph, canvas, CrossProduct));
				};
				else if (ui.button("Length")) {
					pushNode(NodeTypes.createVectorLengthNode(graph, canvas));
				} else if (ui.button(Absolute)) {
					pushNode(NodeTypes.createSecondaryMathNode(graph, canvas, Absolute));
				};
				else if (ui.button(Negate)) {
					pushNode(NodeTypes.createSecondaryMathNode(graph, canvas, Negate));
				};
				else if (ui.button(OneMinus)) {
					pushNode(NodeTypes.createSecondaryMathNode(graph, canvas, OneMinus));
				};
			}
			if (ui.panel(Id.handle(), "Vector", 0, true)) {
				for (i in 0...vectorButtons.length) {
					if (ui.button(vectorNames[i])) {
						pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, vectorButtons[i]), [graph, canvas]));
					};
				}
			}
			if (ui.panel(Id.handle(), "Value", 0, true)) {
				for (i in 0...valueButtons.length) {
					if (ui.button(valueNames[i])) {
						pushNode(cast Reflect.callMethod(NodeTypes, Reflect.field(NodeTypes, valueButtons[i]), [graph, canvas]));
					};
				}
			}
		}

		if (ui.window(Id.handle(), appWidth() - 300, 0, 300, 400, true)) {
			ui.text("Ouput");
			ui.separator();
			ui.image(outputImage);
			if (ui.button("Compile")) {}
			// if(ui.panel(Id.handle(), "Fragment Shader")){
			// }

			// if(ui.panel(Id.handle(), "Vertex Shader")){
			// }
		}
		ui.end();
	}

	function update():Void {
		if (oldX != appWidth() || oldY != appHeight()) {
			oldX = appWidth();
			oldY = appHeight();
			onSizeChanged(appWidth(), appHeight());
		}
	}

	var canvas:TNodeCanvas = {nodes: [], links: []}
}
