package fraggraph;

import zui.Nodes;
import zui.Canvas.TCanvas;
import zui.Nodes.TNode;

@:enum
abstract MathNodeType(String) to String {
	inline var Add = "Add";
	inline var Subtract = "Subtract";
	inline var Multiply = "Multiply";
	inline var Divide = "Divide";
}

@:enum
abstract SecondaryMathNodeTypes(String) to String{
	inline var Absolute = "Absolute";
	inline var OneMinus = "One Minus";
	inline var Negate = "Negate";
}

@:enum
abstract VectorMathNodeType(String) to String {
	inline var DotProduct = "Dot Product";
	inline var CrossProduct = "Cross Product";
}

@:enum
abstract TypeColors(Int) to Int {
	inline var INT = 0xFF225522;
	inline var FLOAT = 0xff449944;
	inline var VECTOR = 0xff6363c7;
	inline var RGB = 0xFFAA22AA;
}

@:enum
abstract InputTypes(String) to String {
	inline var RGBA = "RGBA";
	inline var VALUE = "VALUE";
	inline var VECTOR2 = "VECTOR2";
	inline var VECTOR3 = "VECTOR3";
	inline var VECTOR4 = "VECTOR";
	inline var ENUM = "ENUM";
}

class NodeTypes {
	private static var bufferNode:TNode;
	private static var lastX:Float = 0.0;
	private static var lastY:Float = 0.0;
	private static var cloner:Cloner = new Cloner();

	public static function CopyToBufferNode(node:TNode):Void {
		bufferNode = node;
		lastX = node.x;
		lastY = node.y;
	}

	public static function PasteFromBufferNode(graph:Nodes, canvas:TNodeCanvas):Void {
		if (bufferNode == null)
			return;

		var node = cloner.clone(bufferNode);

		setUniqueIds(node, graph, canvas);
		canvas.nodes.push(node);
		graph.nodeSelected = node;

		lastX -= 15;
		lastY -= 30;

		node.x = lastX;
		node.y = lastY;
	}

	static function setUniqueIds(node:TNode, graph:Nodes, canvas:TNodeCanvas) {
		var nodeID = graph.getNodeId(canvas.nodes);

		node.id = nodeID;

		for (n in node.inputs) {
			n.node_id = nodeID;
			n.id = graph.getSocketId(canvas.nodes);
		}

		for (n in node.outputs) {
			n.node_id = nodeID;
			n.id = graph.getSocketId(canvas.nodes);
		}
	}

	@nodeData("Output", "Surface")
	public static function createSurfaceNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Surface",
			type: "MATERIAL_OUTPUT",
			x: 0,
			y: 0,
			color: 0xffaa4444,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "FragColor",
					type: RGBA,
					default_value: [0, 0, 0, 1.0],
					color: RGB
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Vertex Displacement",
					type: VECTOR2,
					default_value: [0, 0, 0, 0, 0, 0, 0, 0],
					color: VECTOR
				}
			],
			outputs: [],
			buttons: []
		};
	}

	@nodeData("Value", "Time")
	public static function createTimeNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Time",
			type: "Float",
			x: 0,
			y: 0,
			color: FLOAT,
			inputs: [],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "time",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT
				}
			],
			buttons: []
		};
	}

	@nodeData("Texture", "Image")
	public static function createTextureNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Texture",
			type: "TEX_IMAGE",
			x: 0,
			y: 0,
			color: 0xff2222AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "UV",
					type: VECTOR2,
					default_value: [0.0, 0.0, 0.0, 0.0, 0.0],
					color: VECTOR
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: RGBA,
					type: RGBA,
					default_value: [1.0, 1.0, 1.0, 1.0],
					color: RGB
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "R",
					type: VALUE,
					default_value: 0.0,
					color: 0xFFFF0000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "G",
					type: VALUE,
					default_value: 0.0,
					color: 0xFF00FF00
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "B",
					type: VALUE,
					default_value: 0.0,
					color: 0xFF0000FF
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "A",
					type: VALUE,
					default_value: 0,
					color: 0xFFFFFFFF
				}
			],
			buttons: []
		};
	}

	@nodeData("Vector", "Vector 2D")
	public static function createVector2Node(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Vector2",
			type: "VECTOR2",
			x: 0,
			y: 0,
			color: 0xff2222AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "x",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT,
					min: -100000,
					max: 100000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "y",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT,
					min: -100000,
					max: 100000
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Vector",
					type: VECTOR2,
					default_value: [0.0, 0.0],
					color: VECTOR
				}
			],
			buttons: []
		};
	}

	@nodeData("Math")
	public static function createVectorLengthNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Length",
			type: "VECTOR2",
			x: 0,
			y: 0,
			color: 0xff2222AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Vector",
					type: VECTOR4,
					default_value: [0.0,0.0,0.0,0.0],
					color: VECTOR
				}
			
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Length",
					type: VALUE,
					default_value: 0,
					color: FLOAT
				}
			],
			buttons: []
		};
	}

	@nodeData("Vector", "UV Scroller")
	public static function createUVScrollerNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "UV Scroller",
			type: "VECTOR2",
			x: 0,
			y: 0,
			color: 0xff2222AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "speed x",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT,
					max: 10000,
					min: -10000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "speed y",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT,
					max: 10000,
					min: -10000
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Vector",
					type: VECTOR2,
					default_value: [0.0, 0.0],
					color: VECTOR
				}
			],
			buttons: []
		};
	}

	@nodeData("Value", "Screen Resolution")
	public static function createResolutionNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Resolution",
			type: "Uniform",
			x: 0,
			y: 0,
			color: 0xff2222AA,
			inputs: [
				
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Width",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Height",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Width Factor",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Height Factor",
					type: VALUE,
					default_value: 1.0,
					color: FLOAT
				}
			],
			buttons: []
		};
	}

	@nodeData("Value", "Float Value")
	public static function createFloatNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Float",
			type: "VALUE",
			x: 0,
			y: 0,
			color: FLOAT,
			inputs: [],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Value",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT
				}
			],
			buttons: [
				{
					name: "Float",
					type: VALUE,
					output: 0,
					default_value: 0.0,
					min: -100000.0,
					max: 100000.0
				}
			]
		};
	}

	@nodeData("Mesh", "Geometry Data")
	public static function createGeometryNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Geometry",
			type: VALUE,
			x: 0,
			y: 0,
			color: 0xffAA2299,
			inputs: [],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Global Position",
					type: VECTOR3,
					default_value: [0.0, 0.0, 0.0],
					color: VECTOR
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Local Position",
					type: VECTOR3,
					default_value: [0.0, 0.0, 0.0],
					color: VECTOR
				}
			],
			buttons: []
		};
	}

	@nodeData("Color", "RGB value")
	public static function createRGBANode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: RGBA,
			type: RGBA,
			x: 0,
			y: 0,
			color: 0xff2299AA,
			inputs: [],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: RGBA,
					type: RGBA,
					default_value: [1.0, 1.0, 1.0, 1.0],
					color: RGB
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "R",
					type: VALUE,
					default_value: 0.0,
					color: 0xFFFF0000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "G",
					type: VALUE,
					default_value: 0.0,
					color: 0xFF00FF00
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "B",
					type: VALUE,
					default_value: 0.0,
					color: 0xFF0000FF
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "A",
					type: VALUE,
					default_value: 0,
					color: 0xFFFFFFFF
				}
			],
			buttons: [{
				name: RGBA,
				type: RGBA,
				output: 0
			}]
		};
	}

	@nodeData("Color", "Mix Colors")
	public static function createMixColorNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Mix Colors",
			type: "RGBA",
			x: 0,
			y: 0,
			color: 0xff2299AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "factor",
					type: VALUE,
					color: FLOAT,
					default_value: 0.5,
					min: 0,
					max: 1
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "A",
					type: VECTOR4,
					color: RGB,
					default_value: [1.0, 1.0, 1.0, 1.0]
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "B",
					type: VECTOR4,
					color: RGB,
					default_value: [1.0, 1.0, 1.0, 1.0]
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "RGBA",
					type: VECTOR4,
					color: RGB,
					default_value: [1.0, 1.0, 1.0, 1.0]
				}
				
			],
			buttons: []
		};
	}

	@nodeData("Color", "Gradient")
	public static function createGradientNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Gradient",
			type: "RGBA",
			x: 0,
			y: 0,
			color: 0xff2299AA,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Vector",
					type: VECTOR3,
					color: 0xff6363c7,
					default_value: [0.0, 0.0, 0.0]
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Color",
					type: RGBA,
					color: 0xffc7c729,
					default_value: [0.8, 0.8, 0.8, 1.0]
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Fac",
					type: VALUE,
					color: 0xffa1a1a1,
					default_value: 1.0
				}
			],
			buttons: [
				{
					name: "gradient_type",
					type: ENUM,
					// data: ["Linear", "Quadratic", "Easing", "Diagonal", "Radial", "Quadratic Sphere", "Spherical"],
					data: ["Linear", "Diagonal", "Radial", "Spherical"],
					default_value: 0,
					output: 0
				}
			]
		};
	}

	@nodeData("Math")
	public static function createMathNode(graph:Nodes, canvas:TNodeCanvas, type:MathNodeType):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: type,
			type: "Float",
			x: 0,
			y: 0,
			color: 0xff229922,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "A",
					type: VALUE,
					default_value: 0.0,
					color: 0xff44aa44,
					max: 100000,
					min: -100000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "B",
					type: VALUE,
					default_value: 0.0,
					color: 0xff44aa44,
					max: 100000,
					min: -100000
				},

			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Result",
					type: VALUE,
					default_value: 0.0,
					color: 0xff44aa44
				}
			],
			buttons: []
		};
	}

	@nodeData("Math")
	public static function createSecondaryMathNode(graph:Nodes, canvas:TNodeCanvas, type:SecondaryMathNodeTypes):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: type,
			type: VALUE,
			x: 0,
			y: 0,
			color: 0xff229922,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Value",
					type: "float",
					default_value: 0.0,
					color: 0xff44aa44,
					max: 100000,
					min: -100000
				}
			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Result",
					type: VALUE,
					default_value: 0.0,
					color: 0xff44aa44
				}
			],
			buttons: []
		};
	}

	@nodeData("Math")
	public static function createVectorMathNode(graph:Nodes, canvas:TNodeCanvas, type:VectorMathNodeType):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: type,
			type: type == CrossProduct ? VECTOR4:VALUE,
			x: 0,
			y: 0,
			color: VECTOR,
			inputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "A",
					type: VECTOR4,
					default_value: [0.0, 0.0, 0.0, 0.0],
					color: VECTOR,
					max: 100000,
					min: -100000
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "B",
					type: VECTOR4,
					default_value: [0.0, 0.0, 0.0, 0.0],
					color: VECTOR,
					max: 100000,
					min: -100000
				},

			],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "Result",
					type: type == CrossProduct ? VECTOR4:VALUE,
					default_value: type == CrossProduct ? [0.0, 0.0, 0.0, 0.0]:0,
					color:  type == CrossProduct ? VECTOR:FLOAT
				}
			],
			buttons: []
		};
	}

	@nodeData("Mesh", "UV Coordinates")
	public static function createUVCoordNode(graph:Nodes, canvas:TNodeCanvas):TNode {
		var nodeID = graph.getNodeId(canvas.nodes);
		return {
			id: nodeID,
			name: "Texture Coordinates",
			type: "VALUE",
			x: 0,
			y: 0,
			color: 0xff222299,
			inputs: [],
			outputs: [
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "u",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "v",
					type: VALUE,
					default_value: 0.0,
					color: FLOAT
				},
				{
					id: graph.getSocketId(canvas.nodes),
					node_id: nodeID,
					name: "UV",
					type: VECTOR2,
					default_value: [0.0, 0.0, 0.0, 0.0],
					color: VECTOR
				}
			],
			buttons: []
		}
	}
}
