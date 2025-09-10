# pizzaChit

This plugin allows users to reference a yaml file for autocompletion and lookup values.  The goal is to avoid typos.

Why?

I work with yaml files and hate making typos when I look things up.

## Limitations

Yaml key values cannot have spaces in them. IE `Example Key` should be `Example_Key`.

Yaml lists are not supported yet.

# Installation

```
mkdir -p ~/.config/nvim
git clone https://github.com/CleverNamesTaken/pizza_chit.nvim
cp -r pizza_chit.nvim/lua ~/.config/nvim
cp -r pizza_chit.nvim/plugin ~/.config/nvim
echo 'require("pizza_chit.nvim")' >> ~/.config/nvim/init.lua
```

# Tutorial

## Create example yaml file

After installing pizzachit, we first need to create a reference yaml file.

Execute the following in a terminal, or provide your own yaml.

```
cat << EOF >> /tmp/example.yaml
FOOD:
    Italian:
        Pizza:
            Meatlovers: Sausage, bacon, meatballs
            Hawaiian: Pineapple
            Stuffed_Crust: Cheese or something
        Soups:
            Minestrone: Beans or something
            Italian_Wedding: Not sure.  I give up.
    Chinese:
        Noodles:
            Pulled_noodles: Ramen
            Birthday_noodles: Really long noodles
EOF
```

Notice some of the limitations of this yaml file:
1. Keys do not have white space.
2. Lists are not currently supported.

## Check config file

Next, let's make sure our config.lua is pointing at the correct location:

```
cat ~/.config/nvim/lua/pizzachit/config.lua | grep yaml
```

We can point it to whatever valid yaml file.

## Explore the yaml with hotkeys

Start neovim, and go into insert mode.  Use `Ctrl+l` (that is the letter "L") to explore the yaml file.  Continue to press `Ctrl+l` to scroll down the list, or use `Ctrl+p` to go to the previous entry. 

If you see a subkey or value that you are interested in, you can start typing it out and hit `Ctrl+l` to autocomplete it.

# Acknowledgements

Uses https://github.com/LaiYizhou/lua-YAMLParserLite under the hood for the heavy lifting.

# TODO

Add lists support

