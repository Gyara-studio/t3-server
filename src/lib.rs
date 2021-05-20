#![feature(once_cell)]
use std::lazy::SyncLazy;
use gdnative::godot_init;
use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
pub struct Root;

static PORT: SyncLazy<u32> = SyncLazy::new(|| {
    std::env::var("PORT").map(|s| s.parse().expect("Invalid PORT")).unwrap_or(5000)
});

static MAX_PLAYER: SyncLazy<i64> = SyncLazy::new(|| {
    std::env::var("MAX_PLAYER").map(|s| s.parse().expect("Invalid MAX_PLAYER")).unwrap_or(2000)
});

#[methods]
impl Root {
    fn new(_owner: &Node) -> Self {
        Self
    }

    #[export]
    fn regist(&self, _owner: &Node, _user_id: String) {
    }

    #[export]
    fn _ready(&self, _owner: &Node) {
        let tree = gdnative::api::scene_tree::SceneTree::new();
        godot_dbg!(*PORT);
        let enet = gdnative::api::NetworkedMultiplayerENet::new();
        enet.create_server(*PORT as i64, *MAX_PLAYER, 0, 0).unwrap();
        tree.set_network_peer(enet);

    }
}

pub fn init(handle: InitHandle) {
    handle.add_class::<Root>();
}

godot_init!(init);

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
