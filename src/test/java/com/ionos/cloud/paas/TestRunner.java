package com.ionos.cloud.paas;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TestRunner {

    private static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(TestRunner.class);

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:com/ionos/cloud/paas/features")
                .outputCucumberJson(true)
                .outputHtmlReport(false)
                .tags("~@ignore").parallel(1);
        generateReport(results.getReportDir());
        LOGGER.info("reportDir:"+ results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("./target"), "Sample API tests");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

}
