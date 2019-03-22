package fraggraph;

import haxe.macro.*;

class MacroUtil{

    public static macro function getNodeNames(type:Expr, category:String, functionName:Bool = true) {
		var type = Context.typeof(type); // Class<T>
		switch (type) {
			case TType(t, _):
				switch (t.get().type) {
					case TAnonymous(a):
						var fields = a.get().fields;
						var fieldNames = [];
                        for(f in fields){
                            if(f.meta.has("nodeData")){
								var data = f.meta.extract("nodeData");
								switch(data[0].params){
									case [{expr:EConst(CString(cat))}, {expr:EConst(CString(name))}]:
										if(cat == category){
											fieldNames.push(macro $v{functionName ? f.name : name});
										}
									case _:
								}
							}
                        }
						return macro $a{fieldNames};
					case _:
				}
			case _:
		}
		throw 'invalid argument';
	}
}