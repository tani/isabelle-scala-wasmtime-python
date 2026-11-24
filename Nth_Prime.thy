theory Nth_Prime
  imports "HOL-Number_Theory.Eratosthenes" "HOL-Library.Code_Target_Numeral"
begin

primrec nth_prime :: "nat \<Rightarrow> nat" where
  "nth_prime 0 = 2"
| "nth_prime (Suc n) = smallest_prime_beyond (Suc (nth_prime n))"

lemma nth_prime_is_prime [simp]: "prime (nth_prime n)"
  by (cases n) simp_all

lemma nth_prime_rank:
  "card {p. prime p \<and> p < nth_prime n} = n"
proof (induction n)
  case 0
  have "{p::nat. prime p \<and> p < 2} = {}"
    by (auto simp: prime_nat_iff)
  then show ?case by simp
next
  case (Suc n)
  let ?p = "nth_prime n"
  let ?q = "smallest_prime_beyond (Suc ?p)"
  have step: "?p < ?q"
    using smallest_prime_beyond_le [of "Suc ?p"] by arith
  have no_gap: "prime r \<Longrightarrow> r < ?q \<Longrightarrow> r \<le> ?p" for r
    using smallest_prime_beyond_smallest [of r "Suc ?p"] by arith
  have below: "{r. prime r \<and> r < ?q} = insert ?p {r. prime r \<and> r < ?p}"
    using step no_gap by (auto intro: antisym dest: le_neq_implies_less)
  have finite_below: "finite {r. prime r \<and> r < ?p}"
    by (rule finite_subset [of _ "{..< ?p}"]) auto
  show ?case using Suc.IH by (simp add: below finite_below)
qed

definition nth_prime_integer :: "integer \<Rightarrow> integer" where
  "nth_prime_integer n = integer_of_nat (nth_prime (nat_of_integer n))"

export_code nth_prime_integer in Scala module_name PrimeCode file_prefix PrimeCode

end
