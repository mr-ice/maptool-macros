[ data = macro.args ]
[ target = arg(0)]

[h, if( isDialogVisible( target ) ), code: {
	[ macro( "jse.mainDialog.editJSON@this" ): json.get( data, 1 )]
}; {}]
