theory TESLStuttering
imports TESLStutteringLemmas

begin

text {*
  Sporadic specifications are preserved in a dilated run.
*}
lemma sporadic_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c sporadic \<lparr>\<tau>\<rparr> on c'\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c sporadic \<lparr>\<tau>\<rparr> on c'\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f
    where "dilating f sub r" by blast
  hence "\<forall>n c. time ((Rep_run sub) n c) = time ((Rep_run r) (f n) c)
           \<and> hamlet ((Rep_run sub) n c) = hamlet ((Rep_run r) (f n) c)" by (simp add: dilating_def)
  moreover from assms(2) have
    "sub \<in> {r. \<exists> n. hamlet ((Rep_run r) n c) \<and> time ((Rep_run r) n c') = \<tau>}" by simp
  from this obtain k where "time ((Rep_run sub) k c') = \<tau> \<and> hamlet ((Rep_run sub) k c)" by auto
  ultimately have "time ((Rep_run r) (f k) c') = \<tau> \<and> hamlet ((Rep_run r) (f k) c)" by simp
  thus ?thesis by auto
qed

(* Wrong. Not a denotational definition. *)
lemma sporadic_var_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk> c sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(c\<^sub>i, n\<^sub>i) \<oplus> \<delta>\<tau>\<rparr> on c' \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk> c sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(c\<^sub>i, n\<^sub>i) \<oplus> \<delta>\<tau>\<rparr> on c' \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f
    where "dilating f sub r" by blast
  hence "\<forall>n c. time ((Rep_run sub) n c) = time ((Rep_run r) (f n) c)
           \<and> hamlet ((Rep_run sub) n c) = hamlet ((Rep_run r) (f n) c)" by (simp add: dilating_def)
  moreover from assms(2) have
    "sub \<in> {r. \<exists> n. hamlet ((Rep_run r) n c) \<and> time ((Rep_run r) n c') = time ((Rep_run r) n\<^sub>i c\<^sub>i) + \<delta>\<tau>}" by simp
  from this obtain k where "hamlet ((Rep_run sub) k c) \<and> time ((Rep_run sub) k c') = time ((Rep_run sub) n\<^sub>i c\<^sub>i) + \<delta>\<tau>" by blast
  ultimately have "hamlet ((Rep_run r) (f k) c) \<and> time ((Rep_run r) (f k) c') = time ((Rep_run r) (f n\<^sub>i) c\<^sub>i) + \<delta>\<tau>" by simp
  hence "\<exists>n'. hamlet ((Rep_run r) n' c) \<and> time ((Rep_run r) n' c') = time ((Rep_run r) (f n\<^sub>i) c\<^sub>i) + \<delta>\<tau>" by auto
  thus ?thesis oops

text {*
  Implications are preserved in a dilated run.
*}
theorem implies_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 implies c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 implies c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where "dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run r) n c\<^sub>2)}" by simp
  hence "\<forall>n. hamlet ((Rep_run sub) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run sub) n c\<^sub>2)" by simp
  ultimately have "\<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run r) n c\<^sub>2)"
    using ticks_imp_ticks_subk ticks_sub by blast
  thus ?thesis by simp
qed

theorem implies_not_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 implies not c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 implies not c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where "dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run r) n c\<^sub>2)}" by simp
  hence "\<forall>n. hamlet ((Rep_run sub) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run sub) n c\<^sub>2)" by simp
  ultimately have "\<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run r) n c\<^sub>2)"
    using ticks_imp_ticks_subk ticks_sub by blast
  thus ?thesis by simp
qed

text {*
  Precedence relations are preserved in a dilated run.
*}
theorem weakly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 weakly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 weakly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. (run_tick_count r c\<^sub>2 n) \<le> (run_tick_count r c\<^sub>1 n)}" by simp
  hence "\<forall>n. (run_tick_count sub c\<^sub>2 n) \<le> (run_tick_count sub c\<^sub>1 n)" by simp
  hence "\<forall>n. (tick_count sub c\<^sub>2 n) \<le> (tick_count sub c\<^sub>1 n)" using tick_count_is_fun by metis
  ultimately have "\<forall>n. (tick_count r c\<^sub>2 n) \<le> (tick_count r c\<^sub>1 n)"
    using  dil_tick_count tick_count_is_fun assms(1) by metis
  thus ?thesis 
    using TESL_interpretation_atomic.simps(7) assms dil_tick_count by blast
qed

(* Redo all the lemmas for strictly precedes? APITA! *)
theorem strictly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. (run_tick_count r c\<^sub>2 n) \<le> (run_tick_count_strictly r c\<^sub>1 n)}" by simp
  hence "\<forall>n. (run_tick_count sub c\<^sub>2 n) \<le> (run_tick_count_strictly sub c\<^sub>1 n)" by simp
  hence "\<forall>n. (tick_count sub c\<^sub>2 n) \<le> (tick_count_strict sub c\<^sub>1 n)" using tick_count_is_fun tick_count_strict_is_fun by metis
  ultimately have "\<forall>n. (tick_count r c\<^sub>2 n) \<le> (tick_count_strict r c\<^sub>1 n)"
    sorry
  thus ?thesis 
    oops

text {*
  Time delayed relations are preserved in a dilated run.
*}
theorem time_delayed_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk> a time-delayed by \<delta>\<tau> on ms implies b \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk> a time-delayed by \<delta>\<tau> on ms implies b \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) have "\<forall>n. hamlet ((Rep_run sub) n a)
                          \<longrightarrow> (\<exists>m \<ge> n. hamlet ((Rep_run sub) m b)
                                    \<and> time ((Rep_run sub) m ms) =  time ((Rep_run sub) n ms) + \<delta>\<tau>)"
    using TESL_interpretation_atomic.simps(6)[of "a" "\<delta>\<tau>" "ms" "b"] by simp
  hence **:"\<forall>n\<^sub>0. hamlet ((Rep_run r) (f n\<^sub>0) a)
                  \<longrightarrow> (\<exists>m\<^sub>0 \<ge> n\<^sub>0. hamlet ((Rep_run r) (f m\<^sub>0) b)
                             \<and>  time ((Rep_run r) (f m\<^sub>0) ms) = time ((Rep_run r) (f n\<^sub>0) ms) + \<delta>\<tau>)"
    using * by (simp add: dilating_def)
  hence "\<forall>n. hamlet ((Rep_run r) n a)
                  \<longrightarrow> (\<exists>m \<ge> n. hamlet ((Rep_run r) m b)
                             \<and> time ((Rep_run r) m ms) = time ((Rep_run r) n ms) + \<delta>\<tau>)"
  proof -
    { fix n assume assm:"hamlet ((Rep_run r) n a)"
      from ticks_image_sub[OF * assm] obtain n\<^sub>0 where nfn0:"n = f n\<^sub>0" by blast
      with ** assm have
        "(\<exists>m\<^sub>0 \<ge> n\<^sub>0. hamlet ((Rep_run r) (f m\<^sub>0) b)
               \<and>  time ((Rep_run r) (f m\<^sub>0) ms) = time ((Rep_run r) (f n\<^sub>0) ms) + \<delta>\<tau>)" by blast
      hence "(\<exists>m \<ge> n. hamlet ((Rep_run r) m b)
               \<and>  time ((Rep_run r) m ms) = time ((Rep_run r) n ms) + \<delta>\<tau>)"
        using * nfn0 dilating_def dilating_fun_def by (metis strict_mono_less_eq)
    } thus ?thesis by simp
  qed
  thus ?thesis by simp
qed


end
