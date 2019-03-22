package fraggraph;

import fraggraph.NodeTypes.InputTypes;
import zui.Nodes.TNodeLink;
import zui.Nodes.TNodeSocket;
import zui.Nodes.TNode;
import zui.Nodes.TNodeCanvas;
import haxe.ds.GenericStack;

using StringTools;

class GraphParser {
	static var nodes:Array<TNode>;
	static var links:Array<TNodeLink>;
	static var currentNode:GenericStack<NodeIndex> = new GenericStack<NodeIndex>();

	public static function parseToGLSL(nodegraph:TNodeCanvas):Array<String> {
		nodes = nodegraph.nodes;
		links = nodegraph.links;

		var output:TNode = getOutput(nodes);

		if (output != null) {
			traverseTree(output);
			return null;
		}
		return null;
	}

	static function traverseTree(root:TNode):Void {
		//---------------------------------
		// Helper variables
		var link:TNodeLink;
		var node:TNode = null;

		var index = 0;
		var input:TNodeSocket = null;
		var inputLength = 0;
		var leafNode:NodeIndex = null;
		//---------------------------------

		leafNode = {node: root, index: 0};
		currentNode.add(leafNode);

		while (!currentNode.isEmpty()) {
			inputLength = currentNode.first().node.inputs.length - 1;

			if (currentNode.first().index > inputLength) {
				currentNode.pop();
				continue;
			} else {
				do {
					index = currentNode.first().index++;
					input = currentNode.first().node.inputs[index];
					node = getConnectedNode(input);
				} while (index < inputLength && node == null);

				if (node != null) {
					leafNode = {node: node, index: index};
					currentNode.add(leafNode);
					//trace('node: ${node.name}, socket: ${input.name}');
					trace(input.default_value);
				}

			}
		}
	}

	static function getConnectedNode(socket:TNodeSocket):TNode {
		var link:TNodeLink = getInputLink(socket);
		if (link != null) {
			return getNode(link.from_id);
		}
		return null;
	}

	static function parseValue(inp:TNodeSocket):String {
		var l = getInputLink(inp);
		if (l != null) {
			var from = getNode(l.from_id);
			return null;
		}

		return null;
	}

	////
	static function getOutput(nodes:Array<TNode>):TNode {
		for (node in nodes) {
			if (node.type == "MATERIAL_OUTPUT")
				return node;
		}
		return null;
	}

	static function getInputLink(inp:TNodeSocket):TNodeLink {
		for (l in links) {
			if (l.to_id == inp.node_id) {
				var node = getNode(inp.node_id);
				if (node.inputs.length <= l.to_socket)
					return null;
				if (node.inputs[l.to_socket] == inp)
					return l;
			}
		}
		return null;
	}

	static function getNode(id:Int):TNode {
		for (n in nodes)
			if (n.id == id)
				return n;
		return null;
	}
	////
}

typedef NodeIndex = {
	var node:TNode;
	var index:Int;
}
