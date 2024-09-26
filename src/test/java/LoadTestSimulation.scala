import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.core.controller.inject.open.OpenInjectionStep

import scala.concurrent.duration._
import scala.language.postfixOps
import scala.sys.SystemProperties

// Simulation can be parametrized using System properties
// -Dusers the number of users to be used, default 500
// -Dduration the duration of the simulation in seconds, default 225
// -Dtest_feature the test feature for this simulation, possible values: testsample.feature (default)
// -Dinjection_type the injection type for Gatling, possible values: ramp_users (default), stress_peak_users
// more details about Injection can be found in Gatling docs: https://gatling.io/docs/gatling/reference/current/core/injection/
class LoadTestSimulation extends Simulation {
  before {
    println("Load tests started")
  }

  enum InjectionType:
    case ramp_users, stress_peak_users

  val systemProperties = new SystemProperties
  // Number of users
  val numberOfUsers: Int = systemProperties.getOrElse("users", "5").toInt
  // Duration of ramp
  val duration: Int = systemProperties.getOrElse("duration", "200").toInt

  val testFeature: String = systemProperties.getOrElse("test_feature", "testsample.feature")

  val injectionType: InjectionType = InjectionType.valueOf(systemProperties.getOrElse("injection_type", "ramp_users"))

  val heavyLoadTest: ScenarioBuilder = scenario("Load testing feature - "+testFeature).exec(karateFeature("classpath:com/ionos/cloud/paas/features/"+testFeature))

  var injection: OpenInjectionStep = rampUsers(numberOfUsers) during (duration seconds)


  if (injectionType == InjectionType.stress_peak_users ) {
    injection = stressPeakUsers(numberOfUsers) during (duration seconds)
  }

  setUp(
    heavyLoadTest.inject(injection)
  )

  after {
    println("Load tests completed")
  }
}
