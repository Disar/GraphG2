package fraggraph;

import haxe.macro.*;

class MacroUtil{

    public static macro function getNodeNames(type:Expr, category:String) {
		var type = Context.typeof(type); // Class<T>
		switch (type) {
			case TType(t, _):
				switch (t.get().type) {
					case TAnonymous(a):
						var fields = a.get().fields;
						var fieldNames = [];
                        for(f in fields){
                            if(f.meta.has("category")){
								var data = f.meta.extract("category");
								var arg = data[0].params[0].expr;
								switch(arg){
									case EConst(CString(cat)):
										if(cat == category){
											fieldNames.push(macro $v{f.name});
										}
									case _:
										continue;
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