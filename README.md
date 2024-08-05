# 📂 Radial Menu Inspired on 5City 4.0 [STANDALONE]
![image](https://github.com/user-attachments/assets/0f03f18b-8ff6-4f13-b81e-5a0e155a7e7d)

# Usage
If you want add sub menu change `menu` to other item id.
```
addRadialItem({
    menu = 'main_menu',
    id = 'phone',
    label = 'Phone',
    icon = 'fa-thin fa-phone',
    onSelect = function()
        print('Open Phone')
    end
})

removeRadialItem('main_menu', 'phone')
```
