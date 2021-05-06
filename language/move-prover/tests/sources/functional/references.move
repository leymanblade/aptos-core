module 0x42::TestReferences {

    use 0x1::Vector;

    spec module {
        pragma verify = true;
    }

    // ------------------------
    // References as parameters
    // ------------------------

    struct T has copy, drop {
        a: u64
    }

    fun ref_param(r: &T): u64 {
        r.a
    }
    spec fun ref_param {
        ensures result == r.a;
    }

    fun ref_param_vec(r: &vector<T>): u64 {
        Vector::length(r)
    }
    spec fun ref_param_vec {
        ensures result == len(r);
    }

    fun ref_return(r: &vector<T>, i: u64): &T {
        Vector::borrow(r, i)
    }
    spec fun ref_return {
        ensures result == r[i];
    }

    fun increment(r: &mut u64) {
        *r = *r + 1
    }
    spec fun increment {
        ensures r == old(r) + 1;
    }


    // -----------------------------
    // References as local variables
    // -----------------------------

    fun mut_b(b: &mut u64) {
        *b = 10;
    }
    spec fun mut_b {
        ensures b == 10;
    }

    fun mut_ref() {
        let b: u64 = 20;
        let b_ref: &mut u64 = &mut b;
        mut_b(b_ref);
        b = *b_ref;
        if (b != 10) abort 1;
    }
    spec fun mut_ref {
        aborts_if false;
    }

    fun mut_ref_incorrect() {
        let b: u64 = 20;
        let b_ref: &mut u64 = &mut b;
        mut_b(b_ref);
        b = *b_ref;
        if (b != 10) abort 1;
    }
    spec fun mut_ref_incorrect {
        aborts_if true;
    }


    // ---------------------------
    // References as return values
    // ---------------------------

    struct WithdrawalCapability has key {
        account_address: address,
    }

    fun withdrawal_capability_address(cap: &WithdrawalCapability): &address {
        &cap.account_address
    }
    spec fun withdrawal_capability_address {
        ensures result == cap.account_address;
    }

    // ---------------------------
    // References of vector elements
    // ---------------------------

    fun mutate_vector(): vector<u64> {
        let v = Vector::empty();
        Vector::push_back(&mut v, 1);
        let r = Vector::borrow_mut(&mut v, 0);
        *r = 0;
        v
    }
    spec fun mutate_vector {
        ensures result[0] == 0;
    }

    fun mutate_vector_param(v: &mut vector<u64>) {
        let r = Vector::borrow_mut(v, 0);
        *r = *r + 1;
    }
    spec fun mutate_vector_param {
        ensures v[0] == old(v[0]) + 1;
    }
}
