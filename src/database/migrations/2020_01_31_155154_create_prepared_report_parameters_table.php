<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePreparedReportParametersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('prepared_report_parameters', function (Blueprint $table) {
            $table->increments('id');

            $table->string('name', 100);
            $table->string('validation_rules');
            $table->unsignedInteger('prepared_report_id')
                ->index();

            $table->timestamps();

            $table->foreign('prepared_report_id')
                ->references('id')
                ->on('prepared_reports')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('prepared_report_parameters');
    }
}
