# A simple job

It is a delivery / order preparation job. You just have to move an object from point A to point B.

## Easy changes to make

### Change salary
You can simply modify the salary. Salary is a randomized value between Config.MinSalaire and Config.MaxSalaire. You can simply modify those 2 variables to increase or decrease the salary.
```lua
Config.MaxSalaire = 25
Config.MinSalaire = 19
```

Alternatively, you can set a fixed value by commenting line 36 and uncommenting line 37 in client.lua.
```lua
local salaire = math.random(Config.MinSalaire, Config.MaxSalaire)
--local salaire = Config.MaxSalaire
```

### ESX and compatibility with other frameworks
Since ESX is only used to add money to the player once the job is done, you can easily make the script compatible with any framework you want.

### Add more delivries/locations
You just have to modify the config file called config.lua.
You can add more props and more locations by modifying Config.props. 
You can also add more delivry locations by modifying Config.pos.

### En français?
Non, je ne vais pas traduire tout ce que j'ai dit au-dessus... Chaque notification est traduite en français dans client.lua et server.lua. Il suffit de uncomment la ligne en français et commenter la ligne en anglais.
Exemple ligne 44: 
```lua
--drawnotifcolor("Livraison effectuée", 25)
drawnotifcolor("Delivery is done", 25)
```

## Video

![alt text](https://youtu.be/71ZbYwnTUAI)
