module kampus_token::student_reward_token {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::table::{Self, Table};
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;
    use std::string::{Self, String};
    use std::option;
    use std::vector;
    
    // === STRUCTS ===
    
    struct STUDENT_REWARD_TOKEN has drop {}
    
    // Student profile
    struct StudentProfile has key {
        id: UID,
        nim: u32,
        nama: String,
        total_earned: u64,
        total_spent: u64,
        achievements: vector<String>,
    }
    
    // Reward system
    struct RewardSystem has key {
        id: UID,
        treasury_cap: TreasuryCap<STUDENT_REWARD_TOKEN>,
        reward_rates: Table<String, u64>, // Activity -> Token amount
        admin: address,
    }
    
    // Achievement unlocked event
    struct AchievementUnlocked has copy, drop {
        nim: u32,
        achievement: String,
        reward: u64,
    }
    
    // === INIT ===
    fun init(witness: STUDENT_REWARD_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<STUDENT_REWARD_TOKEN>(
            witness,
            6,                                  // 6 decimals
            b"SRT",                            // Symbol  
            b"Student Reward Token",           // Name
            b"Token reward untuk mahasiswa aktif", // Description
            option::none(),                    // No icon
            ctx
        );
        
        // Setup reward rates
        let reward_rates = table::new<String, u64>(ctx);
        table::add(&mut reward_rates, string::utf8(b"attendance"), 10000000); // 10 SRT
        table::add(&mut reward_rates, string::utf8(b"assignment"), 25000000); // 25 SRT
        table::add(&mut reward_rates, string::utf8(b"exam_pass"), 50000000);  // 50 SRT
        table::add(&mut reward_rates, string::utf8(b"project"), 100000000);   // 100 SRT
        
        let reward_system = RewardSystem {
            id: sui::object::new(ctx),
            treasury_cap,
            reward_rates,
            admin: sui::tx_context::sender(ctx),
        };
        
        sui::transfer::share_object(reward_system);
        sui::transfer::public_freeze_object(metadata);
    }
    
    // === STUDENT FUNCTIONS ===
    
    // Register sebagai student
    public fun register_student(
        nim: u32,
        nama: String,
        ctx: &mut TxContext
    ) {
        let profile = StudentProfile {
            id: sui::object::new(ctx),
            nim,
            nama,
            total_earned: 0,
            total_spent: 0,
            achievements: vector::empty<String>(),
        };
        
        sui::transfer::transfer(profile, sui::tx_context::sender(ctx));
    }
    
    // Claim reward untuk achievement
    public fun claim_achievement_reward(
        reward_system: &mut RewardSystem,
        profile: &mut StudentProfile,
        achievement: String,
        ctx: &mut TxContext
    ) {
        // Cek apakah achievement valid
        assert!(table::contains(&reward_system.reward_rates, achievement), 0);
        
        // Get reward amount
        let reward_amount = *table::borrow(&reward_system.reward_rates, achievement);
        
        // Mint reward token
        let reward_coin = coin::mint(&mut reward_system.treasury_cap, reward_amount, ctx);
        
        // Update profile
        profile.total_earned = profile.total_earned + reward_amount;
        vector::push_back(&mut profile.achievements, achievement);
        
        // Emit event
        sui::event::emit(AchievementUnlocked {
            nim: profile.nim,
            achievement,
            reward: reward_amount,
        });
        
        // Transfer reward ke student
        sui::transfer::public_transfer(reward_coin, sui::tx_context::sender(ctx));
    }
    
    // Spend token untuk benefit (contoh: akses premium)
    public fun spend_tokens(
        profile: &mut StudentProfile,
        payment: Coin<STUDENT_REWARD_TOKEN>,
        benefit: String,
        ctx: &TxContext
    ) {
        let amount = coin::value(&payment);
        profile.total_spent = profile.total_spent + amount;
        
        // Transfer payment ke treasury (atau burn)
        sui::transfer::public_transfer(payment, @0x0); // Simplified - send to null
    }
    
    // === VIEW FUNCTIONS ===
    
    // Get student stats
    public fun get_student_stats(profile: &StudentProfile): (u32, String, u64, u64, u64) {
        (
            profile.nim,
            profile.nama,
            profile.total_earned,
            profile.total_spent,
            vector::length(&profile.achievements)
        )
    }
    
    // Get available rewards
    public fun get_reward_rates(reward_system: &RewardSystem): &Table<String, u64> {
        &reward_system.reward_rates
    }
    
    // Get reward amount for achievement
    public fun get_reward_amount(reward_system: &RewardSystem, achievement: String): u64 {
        if (table::contains(&reward_system.reward_rates, achievement)) {
            *table::borrow(&reward_system.reward_rates, achievement)
        } else {
            0
        }
    }
}