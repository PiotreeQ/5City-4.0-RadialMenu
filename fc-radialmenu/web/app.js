var radialItems = [];
let subMenu;
const centerWrapper = document.querySelector('.center-wrapper');

const loadRadial = ((items) => {
    $('.menu-wrapper').empty();
    const nowItems = items;
    if (nowItems && nowItems.length && nowItems.length > 0) {
        const container = document.getElementById('menu-wrapper');
        const radius = 275;
        const centerX = container.offsetWidth / 2;
        const centerY = container.offsetHeight / 2;
        const elementWidth = 200;
        const elementHeight = 40;
        const itemsLength = nowItems.length < 6 ? nowItems.length : 6;
        for (let i = 0; i < itemsLength; i++) {
            const angle = (2 * Math.PI / itemsLength) * i - (Math.PI / 2);
            const adjustedRadius = radius - (elementWidth / 2);
            const x = centerX + adjustedRadius * Math.cos(angle);
            const y = centerY + adjustedRadius * Math.sin(angle);
    
            const nowItem = nowItems[i];
            const $newItem = $(`
            <div style="position: absolute; top: ${y}px; left: ${x}px; width: ${elementWidth}px; height: ${elementHeight}px; display: flex; align-items: center; justify-content: center; text-align: center;" class="item-wrapper">
                <i class="${nowItem.icon}"></i>
                <span>${nowItem.label}</span>
                <div>${parseInt(i) + 1}</div>
            </div>`);
            $('.menu-wrapper').append($newItem);
            $newItem.on('click', () => {
                if (radialItems[nowItem.id]) {
                    subMenu = nowItem.id;
                    let newItems = radialItems[nowItem.id];
                    loadRadial(newItems);
                    centerWrapper.innerHTML = `<i class="fa-regular fa-arrow-rotate-left"></i>`
                    centerWrapper.onclick = (() => {
                        subMenu = null;
                        loadRadial(radialItems['main_menu']);
                        centerWrapper.innerHTML = `<i class="fa-regular fa-xmark"></i>`
                        centerWrapper.onclick = (() => {closeRadial()});
                    })
                } else {
                    $.post('https://fc-radialmenu/SelectItem', JSON.stringify({item: nowItem, subMenu: subMenu}));
                    closeRadial();
                }
            })
        }
    }
})

window.addEventListener("message", (event) => {
    let data = event.data;
    switch (data.action) {
        case 'OpenRadial':
            radialItems = data.items;
            $('.menu-wrapper').css('display', 'flex');
            $('.center-wrapper').fadeIn(300).css('display', 'flex');
            loadRadial(radialItems['main_menu']);
            $('.menu-wrapper').addClass('open');
                setTimeout(() => {
                    $('.menu-wrapper').removeClass('open');
                }, 600);
            break;
        case 'UpdateRadial':
            radialItems = data.items;
            loadRadial(subMenu ? radialItems['main_menu'][subMenu] : radialItems['main_menu'])
            break;
    }
})

const closeRadial = (() => {
    subMenu = null;
    $('.menu-wrapper').addClass('close');
    $('.center-wrapper').fadeOut(300);
    setTimeout(() => {
        $('.menu-wrapper').removeClass('close');
        $('.menu-wrapper').hide();
    }, 550);
    $.post('https://fc-radialmenu/CloseRadial');
})

document.onkeydown = ((e) => {
    if (e.which == 27) {
        closeRadial();
    }
})