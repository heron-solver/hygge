theory Hygge_Theory
imports
  "Corecursive_Prop"
  "Stuttering"

begin

section \<open>Initial configuration\<close>

text \<open>Solving a specification [\<Psi>] means to start operational semantics at initial configuration [], 0 \<turnstile> \<Psi> \<triangleright> []\<close>
theorem solve_start:
  shows "\<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk> [], 0 \<turnstile> \<Psi> \<triangleright> [] \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  proof -
    have "\<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> 0\<^esup>"
    by (simp add: TESL_interpretation_stepwise_zero')
    moreover have "\<lbrakk> [], 0 \<turnstile> \<Psi> \<triangleright> [] \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g = \<lbrakk>\<lbrakk> [] \<rbrakk>\<rbrakk>\<^sub>p\<^sub>r\<^sub>i\<^sub>m \<inter> \<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> 0\<^esup> \<inter> \<lbrakk>\<lbrakk> [] \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> Suc 0\<^esup>"
    by simp
    ultimately show ?thesis by auto
  qed

section \<open>Soundness\<close>

lemma sound_reduction:
  assumes "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1)  \<hookrightarrow>  (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2)"
  shows "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>p\<^sub>r\<^sub>i\<^sub>m \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> n\<^sub>1\<^esup> \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> Suc n\<^sub>1\<^esup>
          \<supseteq>  \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>p\<^sub>r\<^sub>i\<^sub>m \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> n\<^sub>2\<^esup> \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L\<^bsup>\<ge> Suc n\<^sub>2\<^esup>"
proof -
  from assms consider
    (a) "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1)  \<hookrightarrow>\<^sub>i  (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2)"
  | (b) "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1)  \<hookrightarrow>\<^sub>e  (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2)"
    using operational_semantics_step.simps by blast
  thus ?thesis
  proof (cases)
    case a
    thus ?thesis by (simp add: operational_semantics_intro.simps)
  next
    case b thus ?thesis
      apply (rule operational_semantics_elim.cases)
      using HeronConf_interp_stepwise_sporadicon_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_tagrel_cases HeronConf_interpretation.simps apply blast
      using HeronConf_interp_stepwise_implies_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_implies_not_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_timedelayed_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_weakly_precedes_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_strictly_precedes_cases HeronConf_interpretation.simps apply blast+
      using HeronConf_interp_stepwise_kills_cases HeronConf_interpretation.simps apply blast+
    done
  qed
qed

inductive_cases step_elim:"\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2"

lemma sound_reduction':
  assumes "\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
proof -
  from assms consider
    (a) "\<S>\<^sub>1  \<hookrightarrow>\<^sub>i  \<S>\<^sub>2"
  | (b) "\<S>\<^sub>1  \<hookrightarrow>\<^sub>e  \<S>\<^sub>2"
    using step_elim by blast
  thus ?thesis
  proof (cases)
    case a
    thus ?thesis by (rule operational_semantics_intro.cases, simp)
  next
    case b
    thus ?thesis
      apply (rule operational_semantics_elim.cases)
      using HeronConf_interpretation.simps assms sound_reduction apply blast+
    done
  qed
qed

lemma sound_reduction_generalized:
  assumes "\<S>\<^sub>1 \<hookrightarrow>\<^bsup>k\<^esup> \<S>\<^sub>2"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
proof -
  from assms show ?thesis
  proof (induct k arbitrary: \<S>\<^sub>2)
    case 0
      hence *: "\<S>\<^sub>1 \<hookrightarrow>\<^bsup>0\<^esup> \<S>\<^sub>2 \<Longrightarrow> \<S>\<^sub>1 = \<S>\<^sub>2" by auto
      moreover have "\<S>\<^sub>1 = \<S>\<^sub>2" using * "0.prems" by linarith
      ultimately show ?case by auto
  next
    case (Suc k)
      thus ?case
      proof -
        fix k :: nat
        assume ff: "\<S>\<^sub>1 \<hookrightarrow>\<^bsup>Suc k\<^esup> \<S>\<^sub>2"
        assume hi: "\<And>\<S>\<^sub>2. \<S>\<^sub>1 \<hookrightarrow>\<^bsup>k\<^esup> \<S>\<^sub>2 \<Longrightarrow> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<subseteq> \<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        obtain \<S>\<^sub>n where red_decomp: "(\<S>\<^sub>1 \<hookrightarrow>\<^bsup>k\<^esup> \<S>\<^sub>n) \<and> (\<S>\<^sub>n \<hookrightarrow> \<S>\<^sub>2)" using ff by auto
        hence "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<supseteq> \<lbrakk> \<S>\<^sub>n \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g" using hi by simp
        also have "\<lbrakk> \<S>\<^sub>n \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g" by (simp add: red_decomp sound_reduction')
        ultimately show "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g" by simp
      qed
  qed
qed

text \<open>From initial configuration, any reduction step number [k] providing a
      configuration [\<S>] will denote runs from initial specification [\<Psi>].\<close>
theorem soundness:
  assumes "([], 0 \<turnstile> \<Psi> \<triangleright> []) \<hookrightarrow>\<^bsup>k\<^esup> \<S>"
  shows "\<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<supseteq> \<lbrakk> \<S> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  using assms sound_reduction_generalized solve_start by blast

section \<open>Completeness\<close>

lemma complete_direct_successors:
  shows "\<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<subseteq> (\<Union>X\<in>\<C>\<^sub>n\<^sub>e\<^sub>x\<^sub>t (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>). \<lbrakk> X \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
  proof (induct \<Psi>)
    case Nil
    show ?case
      using HeronConf_interp_stepwise_instant_cases operational_semantics_step.simps operational_semantics_intro.instant_i
      by fastforce
  next
    case (Cons \<psi> \<Psi>) print_facts
      then show ?case
      proof (cases \<psi>)
        case (SporadicOn K1 \<tau> K2)
        then show ?thesis 
          using HeronConf_interp_stepwise_sporadicon_cases[of "\<Gamma>" "n" "K1" "\<tau>" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_sporadicon[of "\<Gamma>" "n" "\<Psi>" "K1" "\<tau>" "K2" "\<Phi>"] by blast
      next
        case (TagRelation K\<^sub>1 K\<^sub>2 R)
        then show ?thesis
          using HeronConf_interp_stepwise_tagrel_cases[of "\<Gamma>" "n" "K\<^sub>1" "K\<^sub>2" "R" "\<Psi>" "\<Phi>"]
                Cnext_solve_tagrel[of "K\<^sub>1" "n" "K\<^sub>2" "R" "\<Gamma>" "\<Psi>" "\<Phi>"] by blast
      next
        case (Implies K1 K2)
        then show ?thesis
          using HeronConf_interp_stepwise_implies_cases[of "\<Gamma>" "n" "K1" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_implies[of "K1" "n" "\<Gamma>" "\<Psi>" "K2" "\<Phi>"] by blast
      next
        case (ImpliesNot K1 K2)
        then show ?thesis
          using HeronConf_interp_stepwise_implies_not_cases[of "\<Gamma>" "n" "K1" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_implies_not[of "K1" "n" "\<Gamma>" "\<Psi>" "K2" "\<Phi>"] by blast
      next
        case (TimeDelayedBy Kmast \<tau> Kmeas Kslave)
        thus ?thesis
          using HeronConf_interp_stepwise_timedelayed_cases[of "\<Gamma>" "n" "Kmast" "\<tau>" "Kmeas" "Kslave" "\<Psi>" "\<Phi>"]
                Cnext_solve_timedelayed[of "Kmast" "n" "\<Gamma>" "\<Psi>" "\<tau>" "Kmeas" "Kslave" "\<Phi>"] by blast
      next
        case (WeaklyPrecedes K1 K2)
        then show ?thesis
          using HeronConf_interp_stepwise_weakly_precedes_cases[of "\<Gamma>" "n" "K1" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_weakly_precedes[of "K2" "n" "K1" "\<Gamma>" "\<Psi>"  "\<Phi>"]
          by blast
      next
        case (StrictlyPrecedes K1 K2)
        then show ?thesis
          using HeronConf_interp_stepwise_strictly_precedes_cases[of "\<Gamma>" "n" "K1" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_strictly_precedes[of "K2" "n" "K1" "\<Gamma>" "\<Psi>"  "\<Phi>"]
          by blast
      next
        case (Kills K1 K2)
        then show ?thesis
          using HeronConf_interp_stepwise_kills_cases[of "\<Gamma>" "n" "K1" "K2" "\<Psi>" "\<Phi>"]
                Cnext_solve_kills[of "K1" "n" "\<Gamma>" "\<Psi>" "K2" "\<Phi>"] by blast
      qed
  qed

lemma complete_direct_successors':
  shows "\<lbrakk> \<S> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<subseteq> (\<Union>X\<in>\<C>\<^sub>n\<^sub>e\<^sub>x\<^sub>t \<S>. \<lbrakk> X \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
proof -
  from HeronConf_interpretation.cases obtain \<Gamma> n \<Psi> \<Phi> where "\<S> = (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>)" by blast
  with complete_direct_successors[of "\<Gamma>" "n" "\<Psi>" "\<Phi>"] show ?thesis by simp
qed

lemma branch_existence:
  assumes "\<rho> \<in> \<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  shows "\<exists>\<S>\<^sub>2. (\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2) \<and> (\<rho> \<in> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
  by (metis (mono_tags, lifting) UN_iff assms complete_direct_successors' mem_Collect_eq set_rev_mp)

lemma branch_existence':
  assumes "\<rho> \<in> \<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  shows "\<exists>\<S>\<^sub>2. (\<S>\<^sub>1 \<hookrightarrow>\<^bsup>k\<^esup> \<S>\<^sub>2) \<and> (\<rho> \<in> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
  proof (induct k)
    case 0
    then show ?case
      by (simp add: assms)
  next
    case (Suc k)
    then show ?case
      using branch_existence relpowp_Suc_I[of "k" "operational_semantics_step"] by blast
  qed

text \<open>Any run from initial specification [\<Psi>] has a corresponding configuration
      [\<S>] at any reduction step number [k] starting from initial configuration.\<close>
theorem completeness:
  assumes "\<rho> \<in> \<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
  shows "\<exists>\<S>. (([], 0 \<turnstile> \<Psi> \<triangleright> [])  \<hookrightarrow>\<^bsup>k\<^esup>  \<S>)
           \<and> \<rho> \<in> \<lbrakk> \<S> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  using assms branch_existence' solve_start by blast

section \<open>Progress\<close>

lemma instant_index_increase:
  assumes "\<rho> \<in> \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  shows   "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>)  \<hookrightarrow>\<^bsup>k\<^esup>  (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                         \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  proof (insert assms, induct \<Psi> arbitrary: \<Gamma> \<Phi>)
    case (Nil \<Gamma> \<Phi>)
    then show ?case
      proof -
        have "(\<Gamma>, n \<turnstile> [] \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>1\<^esup> (\<Gamma>, Suc n \<turnstile> \<Phi> \<triangleright> [])"
          using instant_i intro_part
          by fastforce
        moreover have "\<lbrakk> \<Gamma>, n \<turnstile> [] \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g = \<lbrakk> \<Gamma>, Suc n \<turnstile> \<Phi> \<triangleright> [] \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          by auto
        moreover have "\<rho> \<in> \<lbrakk> \<Gamma>, Suc n \<turnstile> \<Phi> \<triangleright> [] \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          using assms Nil.prems calculation(2) by blast
        ultimately show ?thesis by blast
      qed
  next
    case (Cons \<psi> \<Psi>)
  then show ?case
    proof (induct \<psi>)
      case (SporadicOn K\<^sub>1 \<tau> K\<^sub>2)
      have branches: "\<lbrakk> \<Gamma>, n \<turnstile> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi>) \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                    = \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                   \<union> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Down> n @ \<tau>) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using HeronConf_interp_stepwise_sporadicon_cases by simp
          have br1: "\<rho> \<in> \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                  \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
       ((\<Gamma>, n \<turnstile> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and>
       \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h1: "\<rho> \<in> \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and> (\<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
            using h1 SporadicOn.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 sporadic_on_e1)
        qed
      moreover have br2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Down> n @ \<tau>) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
                       ((\<Gamma>, n \<turnstile> ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                      \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Down> n @ \<tau>) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Down> n @ \<tau>) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                  \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h2 SporadicOn.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 sporadic_on_e2)
        qed
      ultimately show ?case
        by (metis SporadicOn.prems(2) UnE branches)
    next
      case (TagRelation K\<^sub>1 K\<^sub>2 R)
      have branches: "\<lbrakk> \<Gamma>, n \<turnstile> ((time-relation \<lfloor>K\<^sub>1, K\<^sub>2\<rfloor> \<in> R) # \<Psi>) \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          = \<lbrakk> ((\<lfloor>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>1, n), \<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n)\<rfloor> \<in> R) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((time-relation \<lfloor>K\<^sub>1, K\<^sub>2\<rfloor> \<in> R) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        using HeronConf_interp_stepwise_tagrel_cases by simp
      then show ?case
        proof -
          have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((((\<lfloor>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>1, n), \<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n)\<rfloor> \<in> R) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((time-relation \<lfloor>K\<^sub>1, K\<^sub>2\<rfloor> \<in> R) # \<Phi>))
              \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using TagRelation.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 tagrel_e)
        qed
    next
      case (Implies K\<^sub>1 K\<^sub>2)
      have branches: "\<lbrakk> \<Gamma>, n \<turnstile> ((K\<^sub>1 implies K\<^sub>2) # \<Psi>) \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          = \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          \<union> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        using HeronConf_interp_stepwise_implies_cases by simp
      have br1: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((\<Gamma>, n \<turnstile> ((K\<^sub>1 implies K\<^sub>2) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                  \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h1: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
                      ((((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                    \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h1 Implies.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 implies_e1)
        qed
        moreover have br2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                            \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
       ((\<Gamma>, n \<turnstile> ((K\<^sub>1 implies K\<^sub>2) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and>
       \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. (
                        (((K\<^sub>1 \<Up> n) # (K\<^sub>2 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 implies K\<^sub>2) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)
                      ) \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h2 Implies.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 implies_e2)
        qed
      ultimately show ?case
        using Implies.prems(2) by fastforce
    next
      case (ImpliesNot K\<^sub>1 K\<^sub>2)
      then show ?case
        by (metis (no_types, lifting) HeronConf_interp_stepwise_implies_not_cases Un_iff elims_part implies_not_e1 implies_not_e2 relpowp_Suc_I2)
    next
      case (TimeDelayedBy K\<^sub>1 \<delta>\<tau> K\<^sub>2 K\<^sub>3)
      have branches: "\<lbrakk> \<Gamma>, n \<turnstile> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi>) \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          = \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          \<union> \<lbrakk> ((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # \<Psi>) \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        using HeronConf_interp_stepwise_timedelayed_cases by simp
      have more_branches:
                "\<lbrakk> ((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # \<Psi>) \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                  = \<lbrakk> ((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
                  \<union> \<lbrakk> ((K\<^sub>3 \<Up> n) # (K\<^sub>2 \<Down> n @ \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr>) # (K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using HeronConf_interp_stepwise_sporadicon_cases by blast
      have br1: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
              \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
               ((\<Gamma>, n \<turnstile> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
              \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h1: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
            ((((K\<^sub>1 \<not>\<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
            \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h1 TimeDelayedBy.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 timedelayed_e1)
        qed
        moreover have br2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
          \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
            ((\<Gamma>, n \<turnstile> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
           \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h2: "\<rho> \<in> \<lbrakk> ((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((((K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>3 sporadic \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr> on K\<^sub>2) # (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h2 TimeDelayedBy.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 timedelayed_e2 sporadic_on_e1)
        qed
        moreover have br2':
          "\<rho> \<in> \<lbrakk> ((K\<^sub>3 \<Up> n) # (K\<^sub>2 \<Down> n @ \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr>) # (K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g
            \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
             ((\<Gamma>, n \<turnstile> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi>) \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
            \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
        proof -
          assume h2: "\<rho> \<in> \<lbrakk> ((K\<^sub>3 \<Up> n) # (K\<^sub>2 \<Down> n @ \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr>) # (K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          then have "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
              ((((K\<^sub>3 \<Up> n) # (K\<^sub>2 \<Down> n @ \<lparr>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rparr>) # (K\<^sub>1 \<Up> n) # \<Gamma>), n \<turnstile> \<Psi> \<triangleright> ((K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>)) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
            \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using h2 TimeDelayedBy.prems by simp
          then show ?thesis
            by (meson elims_part relpowp_Suc_I2 timedelayed_e2 sporadic_on_e2)
        qed
      ultimately show ?case
        using TimeDelayedBy.prems(2) by (metis UnE branches more_branches)
    next
      case (WeaklyPrecedes K\<^sub>1 K\<^sub>2)
      then show ?case
        by (metis (no_types, lifting) HeronConf_interp_stepwise_weakly_precedes_cases elims_part
            weakly_precedes_e relpowp_Suc_I2)
    next
      case (StrictlyPrecedes K\<^sub>1 K\<^sub>2)
      then show ?case
        by (metis (no_types, lifting) HeronConf_interp_stepwise_strictly_precedes_cases elims_part
            strictly_precedes_e relpowp_Suc_I2)
    next
      case (Kills K\<^sub>1 K\<^sub>2)
      then show ?case
        by (metis (no_types, lifting) HeronConf_interp_stepwise_kills_cases UnE
            elims_part kills_e1 kills_e2 relpowp_Suc_I2)
    qed
  qed

lemma instant_index_increase_generalized:
  assumes "n < n\<^sub>k"
  assumes "\<rho> \<in> \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  shows   "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k. ((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, n\<^sub>k \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                         \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, n\<^sub>k \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  proof -
    obtain \<delta>k where diff: "n\<^sub>k = \<delta>k + Suc n"
      using add.commute assms(1) less_iff_Suc_add by auto
    show ?thesis
      proof (subst diff, subst diff, insert assms(2), induct \<delta>k)
        case 0
        then show ?case
          using instant_index_increase assms(2) by simp
      next
        case (Suc \<delta>k)
        have f0: "\<rho> \<in> \<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<Longrightarrow> \<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
             ((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
            \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          using Suc.hyps by blast
        obtain \<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k
          where cont: "((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k)) \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          using f0 assms(1) Suc.prems by blast
        then have fcontinue: "\<exists>\<Gamma>\<^sub>k' \<Psi>\<^sub>k' \<Phi>\<^sub>k' k'. ((\<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k) \<hookrightarrow>\<^bsup>k'\<^esup> (\<Gamma>\<^sub>k', Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k' \<triangleright> \<Phi>\<^sub>k'))
                                              \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k', Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k' \<triangleright> \<Phi>\<^sub>k' \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          using f0 cont instant_index_increase by blast
        obtain \<Gamma>\<^sub>k' \<Psi>\<^sub>k' \<Phi>\<^sub>k' k' where cont2: "((\<Gamma>\<^sub>k, \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k) \<hookrightarrow>\<^bsup>k'\<^esup> (\<Gamma>\<^sub>k', Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k' \<triangleright> \<Phi>\<^sub>k'))
                                            \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k', Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k' \<triangleright> \<Phi>\<^sub>k' \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
          using Suc.prems using fcontinue cont by blast
        have trans: "(\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k + k'\<^esup> (\<Gamma>\<^sub>k', Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k' \<triangleright> \<Phi>\<^sub>k')"
          using operational_semantics_trans_generalized cont cont2
          by blast
        moreover have suc_assoc: "Suc \<delta>k + Suc n = Suc (\<delta>k + Suc n)"
          by arith
        ultimately show ?case 
          proof (subst suc_assoc)
          show "\<exists>\<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k k.
                 ((\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, Suc (\<delta>k + Suc n) \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, Suc \<delta>k + Suc n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
            using cont2 local.trans by auto
          qed
    qed
  qed

text \<open>Any run from initial specification [\<Psi>] has a corresponding configuration
      indexed at [n]-th instant starting from initial configuration.\<close>
theorem progress:
  assumes "\<rho> \<in> \<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
  shows   "\<exists>k \<Gamma>\<^sub>k \<Psi>\<^sub>k \<Phi>\<^sub>k. (([], 0 \<turnstile> \<Psi> \<triangleright> [])  \<hookrightarrow>\<^bsup>k\<^esup> (\<Gamma>\<^sub>k, n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k))
                         \<and> \<rho> \<in> \<lbrakk> \<Gamma>\<^sub>k, n \<turnstile> \<Psi>\<^sub>k \<triangleright> \<Phi>\<^sub>k \<rbrakk>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  using instant_index_increase_generalized
  by (metis assms neq0_conv relpowp_0_I solve_start)

section \<open>Local termination\<close>

primrec measure_interpretation :: "'\<tau> :: linordered_field TESL_formula \<Rightarrow> nat" ("\<mu>") where
    "\<mu> [] = (0::nat)"
  | "\<mu> (\<phi> # \<Phi>) = (case \<phi> of
                        _ sporadic _ on _ \<Rightarrow> 1 + \<mu> \<Phi>
                      | _                 \<Rightarrow> 2 + \<mu> \<Phi>)"

fun measure_interpretation_config :: "'\<tau> :: linordered_field config \<Rightarrow> nat" ("\<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g") where
    "\<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) = \<mu> \<Psi>"

lemma elimation_rules_strictly_decreasing:
  assumes "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1)  \<hookrightarrow>\<^sub>e  (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2)"
  shows "\<mu> \<Psi>\<^sub>1 > \<mu> \<Psi>\<^sub>2"
  by (insert assms, erule operational_semantics_elim.cases, auto)

lemma elimation_rules_strictly_decreasing_meas:
  assumes "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1)  \<hookrightarrow>\<^sub>e  (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2)"
  shows "(\<Psi>\<^sub>2, \<Psi>\<^sub>1) \<in> measure \<mu>"
  by (insert assms, erule operational_semantics_elim.cases, auto)

lemma elimation_rules_strictly_decreasing_meas':
  assumes "\<S>\<^sub>1  \<hookrightarrow>\<^sub>e  \<S>\<^sub>2"
  shows "(\<S>\<^sub>2, \<S>\<^sub>1) \<in> measure \<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g"
  using elimation_rules_strictly_decreasing_meas
  by (metis assms in_measure measure_interpretation_config.elims)

text \<open>The relation made up of elimination rules is well-founded.\<close>
theorem instant_computation_termination:
  shows "wfP (\<lambda>(\<S>\<^sub>1:: 'a :: linordered_field config) \<S>\<^sub>2. (\<S>\<^sub>1  \<hookrightarrow>\<^sub>e\<^sup>\<leftarrow>  \<S>\<^sub>2))"
  proof (simp add: wfP_def)
    show "wf {((\<S>\<^sub>1:: 'a :: linordered_field config), \<S>\<^sub>2). \<S>\<^sub>1 \<hookrightarrow>\<^sub>e\<^sup>\<leftarrow> \<S>\<^sub>2}"
    proof (rule wf_subset)
      have "measure \<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g = { (\<S>\<^sub>2, (\<S>\<^sub>1:: 'a :: linordered_field config)). \<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<S>\<^sub>2 < \<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g \<S>\<^sub>1 }"
        by (simp add: inv_image_def less_eq measure_def)
      then show "{((\<S>\<^sub>1:: 'a :: linordered_field config), \<S>\<^sub>2). \<S>\<^sub>1 \<hookrightarrow>\<^sub>e\<^sup>\<leftarrow> \<S>\<^sub>2} \<subseteq> (measure \<mu>\<^sub>c\<^sub>o\<^sub>n\<^sub>f\<^sub>i\<^sub>g)"
        using elimation_rules_strictly_decreasing_meas' operational_semantics_elim_inv_def by blast
      show "wf (measure measure_interpretation_config)"
        by simp
    qed
  qed

end