module kampus_token::advanced_kampus_coin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;
    use std::option;
    use std::vector;
    
    // === STRUCTS ===
    
    // One Time Witness
    struct ADVANCED_KAMPUS_COIN has drop {}
    
    // Admin capability
    struct AdminCap has key, store {
        id: UID,
    }
    
    // Treasury management object
    struct Treasury has key {
        id: UID,
        treasury_cap: TreasuryCap<ADVANCED_KAMPUS_COIN>,
        total_supply: u64,
        minting_enabled: bool,
        admin: address,
    }
    
    // Minting event
    struct TokenMinted has copy, drop {
        amount: u64,
        recipient: address,
    }
    
    // Burning event  
    struct TokenBurned has copy, drop {
        amount: u64,
        burner: address,
    }
    
    // === ERROR CONSTANTS ===
    const EMINTING_DISABLED: u64 = 0;
    const ENOT_AUTHORIZED: u64 = 1;
    const EINSUFFICIENT_BALANCE: u64 = 2;
    
    // === INIT FUNCTION ===
    fun init(witness: ADVANCED_KAMPUS_COIN, ctx: &mut TxContext) {
        // Create currency
        let (treasury_cap, metadata) = coin::create_currency<ADVANCED_KAMPUS_COIN>(
            witness,
            9,                                              // 9 decimals
            b"AKAMPUS",                                     // Symbol
            b"Advanced Kampus Token",                       // Name
            b"Advanced token dengan admin control",         // Description
            option::none(),
            ctx
        );
        
        // Create admin capability
        let admin_cap = AdminCap {
            id: sui::object::new(ctx),
        };
        
        // Create treasury management
        let treasury = Treasury {
            id: sui::object::new(ctx),
            treasury_cap,
            total_supply: 0,
            minting_enabled: true,
            admin: sui::tx_context::sender(ctx),
        };
        
        // Transfer admin cap to deployer
        sui::transfer::public_transfer(admin_cap, sui::tx_context::sender(ctx));
        
        // Share treasury for public access
        sui::transfer::share_object(treasury);
        
        // Freeze metadata
        sui::transfer::public_freeze_object(metadata);
    }
    
    // === ADMIN FUNCTIONS ===
    
    // Toggle minting on/off (hanya admin)
    public fun toggle_minting(
        _: &AdminCap,
        treasury: &mut Treasury,
    ) {
        treasury.minting_enabled = !treasury.minting_enabled;
    }
    
    // Mint token dengan kontrol admin
    public fun mint_tokens(
        _: &AdminCap,
        treasury: &mut Treasury,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        // Cek apakah minting enabled
        assert!(treasury.minting_enabled, EMINTING_DISABLED);
        
        // Mint coin
        let coin = coin::mint(&mut treasury.treasury_cap, amount, ctx);
        
        // Update total supply
        treasury.total_supply = treasury.total_supply + amount;
        
        // Emit event
        sui::event::emit(TokenMinted {
            amount,
            recipient,
        });
        
        // Transfer ke recipient
        sui::transfer::public_transfer(coin, recipient);
    }
    
    // Batch mint untuk multiple recipients (simplified for legacy edition)
    public fun batch_mint(
        admin_cap: &AdminCap,
        treasury: &mut Treasury,
        recipients: vector<address>,
        amounts: vector<u64>,
        ctx: &mut TxContext
    ) {
        assert!(treasury.minting_enabled, EMINTING_DISABLED);
        assert!(vector::length(&recipients) == vector::length(&amounts), 100);
        
        // For legacy edition, we'll just mint to first recipient for now
        // In production, this would need proper loop implementation
        if (vector::length(&recipients) > 0) {
            let recipient = *vector::borrow(&recipients, 0);
            let amount = *vector::borrow(&amounts, 0);
            mint_tokens(admin_cap, treasury, amount, recipient, ctx);
        };
    }
    
    // === PUBLIC FUNCTIONS ===
    
    // Burn token (siapa saja bisa burn token mereka)
    public fun burn_tokens(
        treasury: &mut Treasury,
        coin: Coin<ADVANCED_KAMPUS_COIN>,
        ctx: &TxContext
    ) {
        let amount = coin::value(&coin);
        
        // Burn coin
        coin::burn(&mut treasury.treasury_cap, coin);
        
        // Update total supply
        treasury.total_supply = treasury.total_supply - amount;
        
        // Emit event
        sui::event::emit(TokenBurned {
            amount,
            burner: sui::tx_context::sender(ctx),
        });
    }
    
    // Split coin menjadi beberapa bagian
    public fun split_coin(
        coin: &mut Coin<ADVANCED_KAMPUS_COIN>,
        split_amount: u64,
        ctx: &mut TxContext
    ): Coin<ADVANCED_KAMPUS_COIN> {
        assert!(coin::value(coin) >= split_amount, EINSUFFICIENT_BALANCE);
        coin::split(coin, split_amount, ctx)
    }
    
    // Join multiple coins menjadi satu
    public fun join_coins(
        coin1: &mut Coin<ADVANCED_KAMPUS_COIN>,
        coin2: Coin<ADVANCED_KAMPUS_COIN>
    ) {
        coin::join(coin1, coin2);
    }
    
    // === VIEW FUNCTIONS ===
    
    // Get treasury info
    public fun get_treasury_info(treasury: &Treasury): (u64, bool, address) {
        (treasury.total_supply, treasury.minting_enabled, treasury.admin)
    }
    
    // Get coin value
    public fun get_coin_value(coin: &Coin<ADVANCED_KAMPUS_COIN>): u64 {
        coin::value(coin)
    }
    
    // Check if minting enabled
    public fun is_minting_enabled(treasury: &Treasury): bool {
        treasury.minting_enabled
    }
}