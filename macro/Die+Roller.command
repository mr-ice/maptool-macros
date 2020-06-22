[h: fail=input(

"num_dice | 0,1,2,3,4,5,6,7,8,9,10 | How many dice | list | select=1",
"num_sides | 2,3,4,6,8,10,12,20,100 | Sided dice | list | value=string",
"roll_bonus | 0 | Dice roll bonus | text",
"show | 0 | Show only to Keeper | check"

)]


[h: abort(fail)]


[h, c(num_dice): eval("roll" + roll.count + "=" + roll(1,num_sides))]

[h: total=0]
[h, c(num_dice): total=total + eval("roll" + roll.count)]
[h: total=total+roll_bonus]


[r, if(show==0), code: { 


   [r: getName() + " rolled <b>" + num_dice + "d" + num_sides + "+" + roll_bonus + "</b><br>"]
   [r, c(num_dice,""): "roll" + (roll.count+1) + ": <b>" + eval("roll" + roll.count) + "</b><br>"]
   [r: "+<b>" + roll_bonus + "</b><br>"]
   [r: "Total= <b>" + total + "</b>"]



};{}]

[g, if(show==1), code: { 


   [r: getName() + " rolled <b>" + num_dice + "d" + num_sides + "+" + roll_bonus + "</b><br>"]
   [r, c(num_dice,""): "roll" + (roll.count+1) + ": <b>" + eval("roll" + roll.count) + "</b><br>"]
   [r: "+<b>" + roll_bonus + "</b><br>"]
   [r: "Total= <b>" + total + "</b>"]



};{}]