# README

## Description
Linky is a game with dots and lines <br />
![game_in_progress](https://user-images.githubusercontent.com/6407580/47387502-d1d9e700-d70f-11e8-9ff0-0b5fe7525f94.png)

## Launch the game
Linux only:<br />
Simply execute the file build/Linky to launch the game.<br />
/!\ The refresh of the mouse doesn't have the same behavior during the development and when the executable file is used which occur the lines not to be draw instantly. This need to be fixed
# Contribute
## System dependencies
```
$ sudo apt install ruby-dev
```
Using the awesome framework ruby2d, follow [this page](http://www.ruby2d.com/learn/get-started/) to install it

## Launch the app
```
$ ruby lib/main.rb
```

### You can submit levels
Here are the tiles positions:<br />
<br />
![grid_tiles_number](https://user-images.githubusercontent.com/6407580/47387507-d3a3aa80-d70f-11e8-8761-d9d2c0cc64a2.png)<br />
Please submit by creating a pull request where you have modify the file lib/levels/dots_position.rb. The numbers are the position of the two dots and grid_size determine the number of rows and columns:<br />
```
  {
    grid_size: 5,
    dots: {
      green: [0, 23],
      blue: [1, 12],
      yellow: [8, 11],
      red: [16, 24]
    }
  }
```
The above example will generate:<br />
<br />
![game_start](https://user-images.githubusercontent.com/6407580/47387499-cedef680-d70f-11e8-8391-53a6ada43259.png)<br />
Where the possible color names are:<br />
blue aqua teal olive green lime yellow orange red brown fuchsia purple maroon white
### TODO
- Add the possibility to build level with dead tiles<br />
- Send coordonates of tiles with alphanumeric value (A1, C3) instead of the number of the tile and manage correctly different grid size<br />
- Fix issue with mouse once compilation is done
