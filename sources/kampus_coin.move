module kampus_token::kampus_coin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::tx_context::TxContext;
    use std::option;
    
    // === STRUCTS ===
    
    // One Time Witness untuk inisialisasi token
    struct KAMPUS_COIN has drop {}
    
    // === INIT FUNCTION ===
    fun init(witness: KAMPUS_COIN, ctx: &mut TxContext) {
        // Metadata token
        let (treasury_cap, metadata) = coin::create_currency<KAMPUS_COIN>(
            witness,
            9,                                          // Decimals
            b"KAMPUS",                                  // Symbol
            b"Kampus Token",                            // Name  
            b"Token untuk sistem kampus blockchain",    // Description
            option::none(), // No icon
            ctx
        );
        
        // Transfer treasury ke deployer untuk kontrol minting
        sui::transfer::public_transfer(treasury_cap, sui::tx_context::sender(ctx));
        
        // Freeze metadata (tidak bisa diubah lagi)
        sui::transfer::public_freeze_object(metadata);
    }
    
    // === MINTING FUNCTIONS ===
    
    // Mint token baru (hanya pemilik treasury)
    public fun mint(
        treasury_cap: &mut TreasuryCap<KAMPUS_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        // Mint coin
        let coin = coin::mint(treasury_cap, amount, ctx);
        
        // Transfer ke recipient
        sui::transfer::public_transfer(coin, recipient);
    }
    
    // Burn token (destroy coin)
    public fun burn(treasury_cap: &mut TreasuryCap<KAMPUS_COIN>, coin: Coin<KAMPUS_COIN>) {
        coin::burn(treasury_cap, coin);
    }
}